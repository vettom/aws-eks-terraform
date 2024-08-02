module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.19.0"

  cluster_name    = "eks-demo"
  cluster_version = "1.30"

  cluster_endpoint_public_access           = true
  enable_irsa                              = true
  vpc_id                                   = module.vpc.vpc_id
  subnet_ids                               = module.vpc.private_subnets
  control_plane_subnet_ids                 = module.vpc.private_subnets
  authentication_mode                      = "API_AND_CONFIG_MAP"
  enable_cluster_creator_admin_permissions = true

  eks_managed_node_groups = {
    eks_nodegroup_1 = {
      min_size       = 1
      max_size       = 4
      desired_size   = 1
      instance_types = ["m6a.large"]
      capacity_type  = "SPOT"
      update_config = {
        max_unavailable_percentage = 33
      }
    }
  }
}
