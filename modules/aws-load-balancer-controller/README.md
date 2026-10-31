# AWS Load Balancer Controller Module

Deploys the AWS Load Balancer Controller to an EKS cluster using Helm with IRSA.

## Features

- IAM policy from official AWS documentation
- IRSA (IAM Roles for Service Accounts) integration
- Configurable resource limits and replica count
- Pinned Helm chart version for reproducibility

## Usage

```hcl
module "aws_load_balancer_controller" {
  source = "./modules/aws-load-balancer-controller"

  prefix            = "my-project"
  environment       = "dev"
  cluster_name      = module.eks.cluster_name
  oidc_provider_arn = module.eks.oidc_provider_arn
  vpc_id            = module.eks.vpc_id
  region            = "ap-southeast-1"

  controller_replica_count = 1

  tags = {
    Environment = "dev"
  }
}
```

## Inputs

| Name | Description | Type | Default |
|------|-------------|------|---------|
| prefix | Resource name prefix | string | - |
| environment | Environment name | string | - |
| cluster_name | EKS cluster name | string | - |
| oidc_provider_arn | OIDC provider ARN | string | - |
| vpc_id | VPC ID | string | - |
| region | AWS region | string | - |
| controller_replica_count | Number of replicas | number | 2 |

## Outputs

| Name | Description |
|------|-------------|
| iam_role_arn | Controller IAM role ARN |
| helm_release_version | Deployed Helm chart version |

<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |
| <a name="provider_helm"></a> [helm](#provider\_helm) | n/a |
| <a name="provider_http"></a> [http](#provider\_http) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_aws_load_balancer_controller_irsa"></a> [aws\_load\_balancer\_controller\_irsa](#module\_aws\_load\_balancer\_controller\_irsa) | terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks | ~> 5.0 |

## Resources

| Name | Type |
|------|------|
| [aws_iam_policy.aws_load_balancer_controller](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [helm_release.aws_load_balancer_controller](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [http_http.aws_load_balancer_controller_policy](https://registry.terraform.io/providers/hashicorp/http/latest/docs/data-sources/http) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | EKS cluster name | `string` | n/a | yes |
| <a name="input_controller_cpu_limit"></a> [controller\_cpu\_limit](#input\_controller\_cpu\_limit) | CPU limit for controller | `string` | `"200m"` | no |
| <a name="input_controller_cpu_request"></a> [controller\_cpu\_request](#input\_controller\_cpu\_request) | CPU request for controller | `string` | `"100m"` | no |
| <a name="input_controller_memory_limit"></a> [controller\_memory\_limit](#input\_controller\_memory\_limit) | Memory limit for controller | `string` | `"512Mi"` | no |
| <a name="input_controller_memory_request"></a> [controller\_memory\_request](#input\_controller\_memory\_request) | Memory request for controller | `string` | `"256Mi"` | no |
| <a name="input_controller_replica_count"></a> [controller\_replica\_count](#input\_controller\_replica\_count) | Number of controller replicas | `number` | `2` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment name (dev, qa, prod) | `string` | n/a | yes |
| <a name="input_oidc_provider_arn"></a> [oidc\_provider\_arn](#input\_oidc\_provider\_arn) | ARN of the OIDC Provider for EKS | `string` | n/a | yes |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | The prefix name of resources | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | AWS region | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Additional tags for all resources | `map(string)` | `{}` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | VPC ID where EKS cluster is deployed | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_helm_release_name"></a> [helm\_release\_name](#output\_helm\_release\_name) | Name of the Helm release |
| <a name="output_helm_release_namespace"></a> [helm\_release\_namespace](#output\_helm\_release\_namespace) | Namespace of the Helm release |
| <a name="output_helm_release_version"></a> [helm\_release\_version](#output\_helm\_release\_version) | Version of the Helm chart deployed |
| <a name="output_iam_policy_arn"></a> [iam\_policy\_arn](#output\_iam\_policy\_arn) | ARN of IAM policy for AWS Load Balancer Controller |
| <a name="output_iam_role_arn"></a> [iam\_role\_arn](#output\_iam\_role\_arn) | ARN of IAM role for AWS Load Balancer Controller |
<!-- END_TF_DOCS -->
