module "tagging" {
  source = "../../../tagging/"
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "21.19.0"

  name               = var.cluster_name
  kubernetes_version = var.cluster_version

  endpoint_public_access   = true
  enable_irsa              = true
  vpc_id                   = var.vpc_id
  subnet_ids               = var.private_subnets
  control_plane_subnet_ids = var.private_subnets
  kms_key_administrators = [
    "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/AtlantisServiceRole",
    "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/BreakGlassAdminRole",
    local.devOpsRole_arn
  ]
  node_security_group_tags = {
    "karpenter.sh/discovery" = var.cluster_name
  }

  iam_role_additional_policies = {
    AmazonEKSVPCResourceController = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  }

  eks_managed_node_groups = {
    eks_nodegroup_1 = {
      ami_type       = "BOTTLEROCKET_x86_64"
      min_size       = var.nodegroup_min_size
      max_size       = var.nodegroup_max_size
      desired_size   = var.nodegroup_desired_size
      instance_types = var.node_instance_type
      capacity_type  = var.node_capacity_type
      update_config = {
        max_unavailable_percentage = 33
      }
      block_device_mappings = {
        xvda = {
          device_name = "/dev/xvda"
          ebs = {
            volume_size           = 2
            volume_type           = "gp3"
            encrypted             = true
            kms_key_id            = data.aws_kms_key.ebs.arn
            delete_on_termination = true
          }
        }
        xvdb = {
          device_name = "/dev/xvdb"
          ebs = {
            volume_size           = var.nodegroup_volume_size
            volume_type           = "gp3"
            encrypted             = true
            kms_key_id            = data.aws_kms_key.ebs.arn
            delete_on_termination = true
          }
        }
      }
    }
  }

  # Fargate Profile(s)
  tags = module.tagging.tags
  # Configre AWS API authentication and roles requiring access to EKS
  authentication_mode = "API"
  cluster_tags = {
    Name      = var.cluster_name
    version   = var.cluster_version
    region    = data.aws_region.current.region
    Terraform = "true"
  }
}
