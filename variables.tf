variable "region" {
  description = "The AWS region to deploy resources"
  type        = string
  default     = "ap-southeast-1" # TODO: Customize
}

variable "env" {
  description = "The environment to deploy (dev, qa, prod)"
  type        = string
}

variable "prefix" {
  description = "The prefix for all resource names"
  type        = string
  default     = "my-project" # TODO: Customize
}

# EKS Configuration Variables
variable "enable_eks" {
  description = "Enable EKS cluster deployment"
  type        = bool
  default     = false
}

variable "enable_alb_controller" {
  description = "Enable AWS Load Balancer Controller deployment"
  type        = bool
  default     = false
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "cluster_version" {
  description = "Kubernetes cluster version"
  type        = string
  default     = "1.31"
}

variable "ami_type" {
  description = "AMI type for EKS nodes"
  type        = string
  default     = "AL2_x86_64"
}

variable "single_nat_gateway" {
  description = "Use single NAT gateway for all private subnets (cost optimization)"
  type        = bool
  default     = true
}

variable "availability_zones_count" {
  description = "Number of availability zones to use for EKS VPC"
  type        = number
  default     = 3
}

variable "node_groups" {
  description = "EKS managed node groups configuration"
  type        = any
  default     = {}
}
