variable "prefix" {
  description = "The prefix name of resources"
  type        = string
}

variable "environment" {
  description = "Environment name (dev, qa, prod)"
  type        = string
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  type        = string
}

variable "availability_zones_count" {
  description = "Number of availability zones to use"
  type        = number
  default     = 3
}

variable "enable_nat_gateway" {
  description = "Enable NAT Gateway for private subnets"
  type        = bool
  default     = true
}

variable "single_nat_gateway" {
  description = "Use a single NAT Gateway for all private subnets"
  type        = bool
  default     = true
}

variable "cluster_version" {
  description = "Kubernetes cluster version"
  type        = string
}

variable "cluster_endpoint_public_access" {
  description = "Enable public access to cluster endpoint"
  type        = bool
  default     = true
}

variable "enable_cluster_creator_admin_permissions" {
  description = "Enable cluster creator admin permissions"
  type        = bool
  default     = true
}

variable "ami_type" {
  description = "AMI type for EKS nodes"
  type        = string
  default     = "AL2_x86_64"
}

variable "node_groups" {
  description = "EKS managed node groups configuration"
  type        = any
  default     = {}
}

variable "tags" {
  description = "Additional tags for all resources"
  type        = map(string)
  default     = {}
}

variable "cni_cleanup_wait_time" {
  description = "Time in seconds to wait after CNI cleanup before proceeding with destroy"
  type        = number
  default     = 30
}
