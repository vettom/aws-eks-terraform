module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "21.15.1"

  name               = "eks-demo"
  kubernetes_version = "1.34"

  endpoint_public_access                   = true
  enable_irsa                              = true
  vpc_id                                   = module.vpc.vpc_id
  subnet_ids                               = module.vpc.private_subnets
  control_plane_subnet_ids                 = module.vpc.private_subnets
  authentication_mode                      = "API"
  enable_cluster_creator_admin_permissions = true

  # addons = {
  #   coredns = {}
  #   eks-pod-identity-agent = {
  #     before_compute = true
  #   }
  #   kube-proxy = {}
  #   vpc-cni = {
  #     before_compute = true
  #   }
  # }

  eks_managed_node_groups = {
    eks_nodegroup_1 = {
      ami_type       = "BOTTLEROCKET_x86_64"
      min_size       = 1
      max_size       = 4
      desired_size   = 1
      instance_types = ["m6a.large", "m6a.xlarge"]
      capacity_type  = "SPOT"
      update_config = {
        max_unavailable_percentage = 33
      }
    }
  }
}
