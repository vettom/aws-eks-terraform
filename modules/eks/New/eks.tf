module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.21"

  name               = "eks-demo"
  kubernetes_version = "1.35"

  endpoint_public_access                   = true
  vpc_id                                   = module.vpc.vpc_id
  subnet_ids                               = module.vpc.private_subnets
  control_plane_subnet_ids                 = module.vpc.private_subnets
  authentication_mode                      = "API"
  enable_cluster_creator_admin_permissions = true

  compute_config = {
    enabled = false
  }
  # Create just the IAM resources for EKS Auto Mode for use with custom node pools
  create_auto_mode_iam_resources = true

  addons = {
    coredns = {}
    eks-pod-identity-agent = {
      before_compute = true
    }
    kube-proxy = {}
    vpc-cni = {
      before_compute = true
    }
  }
  eks_managed_node_groups = {
    eks_nodegroup_1 = {
      ami_type       = "BOTTLEROCKET_x86_64"
      min_size       = 1
      max_size       = 2
      desired_size   = 1
      instance_types = ["m7i.large", "m6i.large", "m5.large"]
      capacity_type  = "SPOT"
    }
  }

  node_security_group_tags = {
    "karpenter.sh/discovery" = "eks-demo"
  }
}
