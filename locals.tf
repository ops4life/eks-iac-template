# Local values for resource naming and common configurations

locals {
  # Resource naming convention: {prefix}-{environment}-{resource-type}-{name}
  resource_prefix = var.prefix != "" ? "${var.prefix}-${var.env}" : var.env

  # Common tags to merge with provider default_tags
  common_tags = {
    Terraform   = "true"
    Project     = var.prefix
    ManagedBy   = "Terraform"
    Environment = var.env
    Region      = var.region
  }

  # Naming patterns
  name_prefix = local.resource_prefix

  # Environment-specific configurations
  is_production = var.env == "prod"
  is_dev        = var.env == "dev"
}
