module "tagging" {
  source = "../../tagging/"
}

#tfsec:ignore:aws-eks-no-public-cluster-access
#tfsec:ignore:aws-eks-no-public-cluster-access-to-cidr
#tfsec:ignore:aws-ec2-no-public-egress-sgr
#tfsec:ignore:aws-eks-enable-control-plane-logging
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 19.17.2"

  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version

  cluster_endpoint_public_access = true
  enable_irsa                    = true
  vpc_id                         = var.vpc_id
  subnet_ids                     = var.private_subnets
  control_plane_subnet_ids       = var.private_subnets
  kms_key_administrators = [
    "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/aws-reserved/sso.amazonaws.com/eu-central-1/AWSReservedSSO_AWSAdministratorAccess_68c50635123a05c6",
    "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/BreakGlassAdminRole",
    "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/atlantis-access-to-dev"
  ]
  node_security_group_tags = {
    "karpenter.sh/discovery" = var.cluster_name
  }

  eks_managed_node_groups = {
    eks_nodegroup_1 = {
      min_size       = var.nodegroup_min_size
      max_size       = var.nodegroup_max_size
      desired_size   = var.nodegroup_desired_size
      instance_types = var.node_instance_type
      capacity_type  = var.node_capacity_type
      update_config = {
        max_unavailable_percentage = 33
      }
    }
  }

  # Fargate Profile(s)
  fargate_profiles = {
    default = {
      name = "default_fargate_profile"
      selectors = [
        {
          namespace = "default"
          labels = {
            platform = "fargate"
          }
        }
      ]
    }
  }

  manage_aws_auth_configmap = true
  aws_auth_roles = [
    {
      rolearn  = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/AWSReservedSSO_AWSAdministratorAccess_68c50635123a05c6"
      username = "AWSAdministratorAccess"
      groups   = ["system:masters"]
    },
    {
      rolearn  = aws_iam_role.karpenter_node_role.arn
      username = "system:node:{{EC2PrivateDNSName}}"
      groups   = ["system:bootstrappers", "system:nodes"]
    },
  ]
  tags = module.tagging.tags

  cluster_tags = {
    Name      = var.cluster_name
    version   = var.cluster_version
    region    = var.region
    Terraform = "true"
  }
}
