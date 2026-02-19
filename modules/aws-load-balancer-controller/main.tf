# AWS Load Balancer Controller Module
# Deploys the AWS Load Balancer Controller to an EKS cluster
# using Terraform and Helm with IAM Roles for Service Accounts (IRSA).

# Data source for AWS Load Balancer Controller IAM policy
data "http" "aws_load_balancer_controller_policy" {
  url = "https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v2.11.0/docs/install/iam_policy.json"
}

# IAM policy for AWS Load Balancer Controller
resource "aws_iam_policy" "aws_load_balancer_controller" {
  name        = "${var.prefix}-${var.environment}-alb-controller-policy"
  description = "IAM policy for AWS Load Balancer Controller"
  policy      = data.http.aws_load_balancer_controller_policy.response_body

  tags = var.tags
}

# IAM role for AWS Load Balancer Controller using IRSA
module "aws_load_balancer_controller_irsa" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "~> 5.0"

  role_name = "${var.prefix}-${var.environment}-alb-controller-role"

  attach_load_balancer_controller_policy = true

  oidc_providers = {
    main = {
      provider_arn               = var.oidc_provider_arn
      namespace_service_accounts = ["kube-system:aws-load-balancer-controller"]
    }
  }

  tags = var.tags
}

# Helm release for AWS Load Balancer Controller
resource "helm_release" "aws_load_balancer_controller" {
  name       = "aws-load-balancer-controller"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  version    = "1.11.0"
  namespace  = "kube-system"

  set = [
    {
      name  = "clusterName"
      value = var.cluster_name
    },
    {
      name  = "serviceAccount.create"
      value = "true"
    },
    {
      name  = "serviceAccount.name"
      value = "aws-load-balancer-controller"
    },
    {
      name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
      value = module.aws_load_balancer_controller_irsa.iam_role_arn
    },
    {
      name  = "region"
      value = var.region
    },
    {
      name  = "vpcId"
      value = var.vpc_id
    },
    {
      name  = "replicaCount"
      value = var.controller_replica_count
    },
    {
      name  = "resources.limits.cpu"
      value = var.controller_cpu_limit
    },
    {
      name  = "resources.limits.memory"
      value = var.controller_memory_limit
    },
    {
      name  = "resources.requests.cpu"
      value = var.controller_cpu_request
    },
    {
      name  = "resources.requests.memory"
      value = var.controller_memory_request
    }
  ]

  depends_on = [
    module.aws_load_balancer_controller_irsa
  ]
}
