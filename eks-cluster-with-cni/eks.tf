module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "19.17.4"

  cluster_name    = eks-demo
  cluster_version = 1.29

  cluster_endpoint_public_access = true
  enable_irsa                    = true
  vpc_id                         = var.vpc_id
  subnet_ids                     = var.private_subnets
  control_plane_subnet_ids       = var.private_subnets
  node_security_group_tags = {
    "karpenter.sh/discovery" = eks-demo
  }
  cluster_additional_security_group_ids = [aws_security_group.lapi-redis-access.id]

  eks_managed_node_groups = {
    eks_nodegroup_1 = {
      min_size       = 1
      max_size       = 4
      desired_size   = 1
      instance_types = m5.large
      capacity_type  = SPOT
      update_config = {
        max_unavailable_percentage = 33
      }
    }
  }

  manage_aws_auth_configmap = false
  # aws_auth_roles = [
  #   {
  #     rolearn  = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/AWSReservedSSO_AWSAdministratorAccess_68c50635123a05c6"
  #     username = "AWSAdministratorAccess"
  #     groups   = ["system:masters"]
  #   },
  #   {
  #     rolearn  = aws_iam_role.karpenter_node_role.arn
  #     username = "system:node:{{EC2PrivateDNSName}}"
  #     groups   = ["system:bootstrappers", "system:nodes"]
  #   },
  # ]

  cluster_tags = {
    Name = eks-demo
  }§
}
