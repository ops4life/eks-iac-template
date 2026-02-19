# Production Environment Configuration

env    = "prod"
region = "ap-southeast-1" # TODO: Customize
prefix = "my-project"     # TODO: Customize

# EKS Configuration
enable_eks               = true
enable_alb_controller    = true
vpc_cidr                 = "10.2.0.0/16"
availability_zones_count = 3 # Multi-AZ for high availability
cluster_version          = "1.31"
ami_type                 = "AL2023_x86_64_STANDARD"
single_nat_gateway       = false # High availability - NAT per AZ

node_groups = {
  spot = {
    name           = "spot-node-group"
    capacity_type  = "SPOT"
    instance_types = ["t3.medium", "t3a.medium"]
    min_size       = 2
    max_size       = 5
    desired_size   = 3
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
    min_size       = 2
    max_size       = 4
    desired_size   = 2
    labels = {
      node-type     = "on-demand"
      workload-type = "critical"
    }
    taints = []
  }
}
