# EKS Module

This module provisions a production-ready EKS cluster with VPC infrastructure.

## Features

- VPC with public and private subnets across multiple AZs
- EKS cluster with managed node groups
- NAT Gateway configuration (single or per-AZ)
- Automatic CNI ENI cleanup on destroy
- Subnet tagging for ALB Ingress controller

## Usage

```hcl
module "eks" {
  source = "./modules/eks"

  prefix      = "my-project"
  environment = "dev"
  vpc_cidr    = "10.0.0.0/16"

  cluster_version          = "1.31"
  availability_zones_count = 2
  single_nat_gateway       = true

  node_groups = {
    spot = {
      name           = "spot-node-group"
      capacity_type  = "SPOT"
      instance_types = ["t3.medium"]
      min_size       = 1
      max_size       = 3
      desired_size   = 2
      labels = {
        node-type = "spot"
      }
      taints = []
    }
  }

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
| vpc_cidr | VPC CIDR block | string | - |
| cluster_version | Kubernetes version | string | - |
| availability_zones_count | Number of AZs | number | 3 |
| single_nat_gateway | Use single NAT gateway | bool | true |
| node_groups | Node group configuration | any | {} |
| tags | Additional tags | map(string) | {} |

## Outputs

| Name | Description |
|------|-------------|
| vpc_id | VPC ID |
| cluster_name | EKS cluster name |
| cluster_endpoint | EKS API endpoint |
| oidc_provider_arn | OIDC provider ARN for IRSA |
| configure_kubectl | kubectl configuration command |

<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |
| <a name="provider_null"></a> [null](#provider\_null) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_eks"></a> [eks](#module\_eks) | terraform-aws-modules/eks/aws | ~> 20.0 |
| <a name="module_vpc"></a> [vpc](#module\_vpc) | terraform-aws-modules/vpc/aws | ~> 5.0 |

## Resources

| Name | Type |
|------|------|
| [null_resource.cleanup_cni](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [aws_availability_zones.available](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ami_type"></a> [ami\_type](#input\_ami\_type) | AMI type for EKS nodes | `string` | `"AL2_x86_64"` | no |
| <a name="input_availability_zones_count"></a> [availability\_zones\_count](#input\_availability\_zones\_count) | Number of availability zones to use | `number` | `3` | no |
| <a name="input_cluster_endpoint_public_access"></a> [cluster\_endpoint\_public\_access](#input\_cluster\_endpoint\_public\_access) | Enable public access to cluster endpoint | `bool` | `true` | no |
| <a name="input_cluster_version"></a> [cluster\_version](#input\_cluster\_version) | Kubernetes cluster version | `string` | n/a | yes |
| <a name="input_cni_cleanup_wait_time"></a> [cni\_cleanup\_wait\_time](#input\_cni\_cleanup\_wait\_time) | Time in seconds to wait after CNI cleanup before proceeding with destroy | `number` | `30` | no |
| <a name="input_enable_cluster_creator_admin_permissions"></a> [enable\_cluster\_creator\_admin\_permissions](#input\_enable\_cluster\_creator\_admin\_permissions) | Enable cluster creator admin permissions | `bool` | `true` | no |
| <a name="input_enable_nat_gateway"></a> [enable\_nat\_gateway](#input\_enable\_nat\_gateway) | Enable NAT Gateway for private subnets | `bool` | `true` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment name (dev, qa, prod) | `string` | n/a | yes |
| <a name="input_node_groups"></a> [node\_groups](#input\_node\_groups) | EKS managed node groups configuration | `any` | `{}` | no |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | The prefix name of resources | `string` | n/a | yes |
| <a name="input_single_nat_gateway"></a> [single\_nat\_gateway](#input\_single\_nat\_gateway) | Use a single NAT Gateway for all private subnets | `bool` | `true` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Additional tags for all resources | `map(string)` | `{}` | no |
| <a name="input_vpc_cidr"></a> [vpc\_cidr](#input\_vpc\_cidr) | The CIDR block for the VPC | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cluster_certificate_authority_data"></a> [cluster\_certificate\_authority\_data](#output\_cluster\_certificate\_authority\_data) | Base64 encoded certificate data required to communicate with the cluster |
| <a name="output_cluster_endpoint"></a> [cluster\_endpoint](#output\_cluster\_endpoint) | Endpoint for EKS control plane |
| <a name="output_cluster_id"></a> [cluster\_id](#output\_cluster\_id) | The ID of the EKS cluster |
| <a name="output_cluster_name"></a> [cluster\_name](#output\_cluster\_name) | The name of the EKS cluster |
| <a name="output_cluster_security_group_id"></a> [cluster\_security\_group\_id](#output\_cluster\_security\_group\_id) | Security group ID attached to the EKS cluster |
| <a name="output_cluster_version"></a> [cluster\_version](#output\_cluster\_version) | The Kubernetes version for the cluster |
| <a name="output_configure_kubectl"></a> [configure\_kubectl](#output\_configure\_kubectl) | Command to configure kubectl |
| <a name="output_node_security_group_id"></a> [node\_security\_group\_id](#output\_node\_security\_group\_id) | Security group ID attached to the EKS nodes |
| <a name="output_oidc_provider_arn"></a> [oidc\_provider\_arn](#output\_oidc\_provider\_arn) | ARN of the OIDC Provider for EKS |
| <a name="output_private_subnets"></a> [private\_subnets](#output\_private\_subnets) | List of IDs of private subnets |
| <a name="output_public_subnets"></a> [public\_subnets](#output\_public\_subnets) | List of IDs of public subnets |
| <a name="output_vpc_cidr"></a> [vpc\_cidr](#output\_vpc\_cidr) | The CIDR block of the VPC |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | The ID of the VPC |
<!-- END_TF_DOCS -->
