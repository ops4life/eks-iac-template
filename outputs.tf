# Root-level outputs

output "environment" {
  description = "The environment name"
  value       = var.env
}

output "region" {
  description = "The AWS region where resources are deployed"
  value       = var.region
}

output "resource_prefix" {
  description = "The prefix used for resource naming"
  value       = local.resource_prefix
}

# EKS Cluster Outputs
output "eks_cluster_name" {
  description = "The name of the EKS cluster"
  value       = var.enable_eks ? module.eks[0].cluster_name : null
}

output "eks_cluster_endpoint" {
  description = "Endpoint for EKS control plane"
  value       = var.enable_eks ? module.eks[0].cluster_endpoint : null
}

output "eks_cluster_security_group_id" {
  description = "Security group ID attached to the EKS cluster"
  value       = var.enable_eks ? module.eks[0].cluster_security_group_id : null
}

output "eks_vpc_id" {
  description = "The ID of the VPC created for EKS"
  value       = var.enable_eks ? module.eks[0].vpc_id : null
}

output "eks_private_subnets" {
  description = "List of IDs of private subnets"
  value       = var.enable_eks ? module.eks[0].private_subnets : null
}

output "eks_public_subnets" {
  description = "List of IDs of public subnets"
  value       = var.enable_eks ? module.eks[0].public_subnets : null
}

output "configure_kubectl" {
  description = "Command to configure kubectl for EKS cluster access"
  value       = var.enable_eks ? module.eks[0].configure_kubectl : null
}

output "eks_oidc_provider_arn" {
  description = "ARN of the OIDC Provider for EKS (for IRSA)"
  value       = var.enable_eks ? module.eks[0].oidc_provider_arn : null
}

# AWS Load Balancer Controller Outputs
output "alb_controller_iam_role_arn" {
  description = "ARN of IAM role for AWS Load Balancer Controller"
  value       = var.enable_eks && var.enable_alb_controller ? module.aws_load_balancer_controller[0].iam_role_arn : null
}

output "alb_controller_version" {
  description = "Version of AWS Load Balancer Controller Helm chart"
  value       = var.enable_eks && var.enable_alb_controller ? module.aws_load_balancer_controller[0].helm_release_version : null
}
