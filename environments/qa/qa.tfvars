# QA/Staging Environment Configuration

env    = "qa"
region = "ap-southeast-1" # TODO: Customize
prefix = "my-project"     # TODO: Customize

# EKS Configuration
enable_eks               = true
enable_alb_controller    = true
vpc_cidr                 = "10.1.0.0/16"
availability_zones_count = 3 # Production-like multi-AZ setup
cluster_version          = "1.31"
ami_type                 = "AL2023_x86_64_STANDARD"
single_nat_gateway       = true # Cost optimization

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
  on_demand = {
    name           = "on-demand-node-group"
    capacity_type  = "ON_DEMAND"
    instance_types = ["t3.medium"]
    min_size       = 1
    max_size       = 2
    desired_size   = 1
    labels = {
      node-type     = "on-demand"
      workload-type = "critical"
    }
    taints = []
  }
}
