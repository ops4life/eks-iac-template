# Configure the AWS Provider
provider "aws" {
  region = var.region
  default_tags {
    tags = {
      ManagedBy   = "Terraform"
      Environment = var.env
    }
  }
}

# Helm Provider for deploying Helm charts to EKS
provider "helm" {
  kubernetes = {
    host                   = var.enable_eks ? module.eks[0].cluster_endpoint : ""
    cluster_ca_certificate = var.enable_eks ? base64decode(module.eks[0].cluster_certificate_authority_data) : ""

    exec = {
      api_version = "client.authentication.k8s.io/v1beta1"
      command     = "aws"
      args = [
        "eks",
        "get-token",
        "--cluster-name",
        var.enable_eks ? module.eks[0].cluster_name : ""
      ]
    }
  }
}

# Kubernetes Provider for managing Kubernetes resources
provider "kubernetes" {
  host                   = var.enable_eks ? module.eks[0].cluster_endpoint : ""
  cluster_ca_certificate = var.enable_eks ? base64decode(module.eks[0].cluster_certificate_authority_data) : ""

  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    args = [
      "eks",
      "get-token",
      "--cluster-name",
      var.enable_eks ? module.eks[0].cluster_name : ""
    ]
  }
}
