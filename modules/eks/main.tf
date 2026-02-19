# VPC Module for EKS
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = "${var.prefix}-${var.environment}-vpc"

  cidr = var.vpc_cidr
  azs  = local.azs

  private_subnets = [for k, v in local.azs : cidrsubnet(var.vpc_cidr, 4, k)]
  public_subnets  = [for k, v in local.azs : cidrsubnet(var.vpc_cidr, 8, k + 48)]

  enable_nat_gateway   = var.enable_nat_gateway
  single_nat_gateway   = var.single_nat_gateway
  enable_dns_hostnames = true

  public_subnet_tags = {
    "kubernetes.io/role/elb" = 1
  }

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = 1
  }

  tags = var.tags
}

# EKS Cluster Module
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = "${var.prefix}-${var.environment}-cluster"
  cluster_version = var.cluster_version

  cluster_endpoint_public_access           = var.cluster_endpoint_public_access
  enable_cluster_creator_admin_permissions = var.enable_cluster_creator_admin_permissions

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  eks_managed_node_group_defaults = {
    ami_type = var.ami_type
  }

  eks_managed_node_groups = var.node_groups

  tags = var.tags
}

# Data sources
data "aws_availability_zones" "available" {
  filter {
    name   = "opt-in-status"
    values = ["opt-in-not-required"]
  }
}

data "aws_region" "current" {}

locals {
  azs = slice(data.aws_availability_zones.available.names, 0, var.availability_zones_count)
}

# Cleanup CNI ENIs before cluster destruction
# This prevents security group deletion failures caused by orphaned ENIs
resource "null_resource" "cleanup_cni" {
  triggers = {
    cluster_name      = module.eks.cluster_name
    vpc_id            = module.vpc.vpc_id
    region            = data.aws_region.current.name
    cleanup_wait_time = var.cni_cleanup_wait_time
  }

  provisioner "local-exec" {
    when    = destroy
    command = <<-EOT
      echo "Cleaning up CNI ENIs for cluster ${self.triggers.cluster_name}..."

      # Find all ENIs associated with the EKS cluster
      eni_ids=$(aws ec2 describe-network-interfaces \
        --region ${self.triggers.region} \
        --filters "Name=vpc-id,Values=${self.triggers.vpc_id}" \
                  "Name=description,Values=*${self.triggers.cluster_name}*" \
                  "Name=status,Values=available,in-use" \
        --query 'NetworkInterfaces[?starts_with(Description, `aws-K8S-`) || contains(Description, `eks`)].NetworkInterfaceId' \
        --output text)

      if [ -n "$eni_ids" ]; then
        echo "Found ENIs to clean up: $eni_ids"
        for eni_id in $eni_ids; do
          echo "Attempting to delete ENI: $eni_id"
          # Detach if attached
          attachment_id=$(aws ec2 describe-network-interfaces \
            --region ${self.triggers.region} \
            --network-interface-ids $eni_id \
            --query 'NetworkInterfaces[0].Attachment.AttachmentId' \
            --output text 2>/dev/null)

          if [ "$attachment_id" != "None" ] && [ -n "$attachment_id" ]; then
            echo "Detaching ENI $eni_id (attachment: $attachment_id)..."
            aws ec2 detach-network-interface \
              --region ${self.triggers.region} \
              --attachment-id $attachment_id 2>/dev/null || true
            sleep 5
          fi

          # Delete the ENI
          aws ec2 delete-network-interface \
            --region ${self.triggers.region} \
            --network-interface-id $eni_id 2>/dev/null || \
            echo "Could not delete ENI $eni_id (may already be deleted)"
        done

        echo "Waiting for ENI cleanup to complete..."
        sleep ${self.triggers.cleanup_wait_time}
      else
        echo "No CNI ENIs found to clean up"
      fi

      echo "CNI cleanup completed"
    EOT
  }

  depends_on = [
    module.eks
  ]
}
