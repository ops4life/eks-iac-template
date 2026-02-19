terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 3.1"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 3.0"
    }
    http = {
      source  = "hashicorp/http"
      version = "~> 3.0"
    }
  }

  # TODO: Customize - Uncomment and configure for remote state
  # backend "s3" {
  #   bucket         = "my-project-terraform-state"
  #   key            = "eks/terraform.tfstate"
  #   region         = "ap-southeast-1"
  #   dynamodb_table = "my-project-terraform-locks"
  #   encrypt        = true
  # }
}
