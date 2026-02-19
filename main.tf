# Main Terraform Configuration
# This is the root module that orchestrates all infrastructure components

# EKS Cluster Module
# Provisions a complete EKS infrastructure including VPC, cluster, and managed node groups
module "eks" {
  count  = var.enable_eks ? 1 : 0
  source = "./modules/eks"

  prefix      = var.prefix
  environment = var.env
  vpc_cidr    = var.vpc_cidr

  cluster_version = var.cluster_version
  ami_type        = var.ami_type

  availability_zones_count = var.availability_zones_count
  single_nat_gateway       = var.single_nat_gateway

  node_groups = var.node_groups

  tags = local.common_tags
}

# AWS Load Balancer Controller Module
# Deploys AWS Load Balancer Controller for ALB/NLB provisioning via Ingress
module "aws_load_balancer_controller" {
  count  = var.enable_eks && var.enable_alb_controller ? 1 : 0
  source = "./modules/aws-load-balancer-controller"

  prefix            = var.prefix
  environment       = var.env
  cluster_name      = module.eks[0].cluster_name
  oidc_provider_arn = module.eks[0].oidc_provider_arn
  vpc_id            = module.eks[0].vpc_id
  region            = var.region

  # Environment-specific configurations
  controller_replica_count  = local.is_production ? 2 : 1
  controller_cpu_limit      = local.is_production ? "200m" : "100m"
  controller_memory_limit   = local.is_production ? "512Mi" : "256Mi"
  controller_cpu_request    = local.is_production ? "100m" : "50m"
  controller_memory_request = local.is_production ? "256Mi" : "128Mi"

  tags = local.common_tags

  depends_on = [module.eks]
}
