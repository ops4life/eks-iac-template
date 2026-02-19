variable "prefix" {
  description = "The prefix name of resources"
  type        = string
}

variable "environment" {
  description = "Environment name (dev, qa, prod)"
  type        = string
}

variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
}

variable "oidc_provider_arn" {
  description = "ARN of the OIDC Provider for EKS"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where EKS cluster is deployed"
  type        = string
}

variable "region" {
  description = "AWS region"
  type        = string
}

variable "controller_replica_count" {
  description = "Number of controller replicas"
  type        = number
  default     = 2
}

variable "controller_cpu_limit" {
  description = "CPU limit for controller"
  type        = string
  default     = "200m"
}

variable "controller_memory_limit" {
  description = "Memory limit for controller"
  type        = string
  default     = "512Mi"
}

variable "controller_cpu_request" {
  description = "CPU request for controller"
  type        = string
  default     = "100m"
}

variable "controller_memory_request" {
  description = "Memory request for controller"
  type        = string
  default     = "256Mi"
}

variable "tags" {
  description = "Additional tags for all resources"
  type        = map(string)
  default     = {}
}
