output "iam_role_arn" {
  description = "ARN of IAM role for AWS Load Balancer Controller"
  value       = module.aws_load_balancer_controller_irsa.iam_role_arn
}

output "iam_policy_arn" {
  description = "ARN of IAM policy for AWS Load Balancer Controller"
  value       = aws_iam_policy.aws_load_balancer_controller.arn
}

output "helm_release_name" {
  description = "Name of the Helm release"
  value       = helm_release.aws_load_balancer_controller.name
}

output "helm_release_namespace" {
  description = "Namespace of the Helm release"
  value       = helm_release.aws_load_balancer_controller.namespace
}

output "helm_release_version" {
  description = "Version of the Helm chart deployed"
  value       = helm_release.aws_load_balancer_controller.version
}
