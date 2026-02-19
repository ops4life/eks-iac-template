# Development Environment Configuration

env    = "dev"
region = "ap-southeast-1" # TODO: Customize
prefix = "my-project"     # TODO: Customize

# EKS Configuration
enable_eks               = true
enable_alb_controller    = true
vpc_cidr                 = "10.0.0.0/16"
availability_zones_count = 2 # EKS requires minimum 2 AZs
cluster_version          = "1.31"
ami_type                 = "AL2023_x86_64_STANDARD"
single_nat_gateway       = true # Cost optimization for dev

node_groups = {
  spot = {
    name           = "spot-node-group"
    capacity_type  = "SPOT"
    instance_types = ["t3.medium", "t3a.medium"]
    min_size       = 1
    max_size       = 3
    desired_size   = 2
    labels = {
      node-type     = "spot"
      workload-type = "stateless"
    }
    taints = []
  }
}
