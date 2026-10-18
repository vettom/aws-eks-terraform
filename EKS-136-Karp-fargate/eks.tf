module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.21"

  name               = var.cluster_name
  kubernetes_version = var.cluster_version

  vpc_id                                   = data.aws_vpc.this.id
  subnet_ids                               = data.aws_subnets.private.ids
  authentication_mode                      = "API"
  enable_cluster_creator_admin_permissions = true
  endpoint_public_access                   = true
  endpoint_public_access_cidrs             = ["0.0.0.0/0"]
  enable_irsa                              = true

  compute_config = {
    enabled = false
  }

  # Disable cloudwatch logging for EKS
  enabled_log_types                      = []
  cloudwatch_log_group_retention_in_days = 7

  addons = {
    vpc-cni = {
      before_compute = true
      most_recent    = true
      addon_version  = data.aws_eks_addon_version.vpc_cni.version

      configuration_values = jsonencode({
        env = {
          AWS_VPC_K8S_CNI_CUSTOM_NETWORK_CFG = "true"
          ENABLE_POD_ENI                     = "true"
          ENABLE_PREFIX_DELEGATION           = "true"
          ENABLE_SUBNET_DISCOVERY            = "true"

          # CRITICAL ADDITION:
          # Tells the nodes to look for an ENIConfig matching their AZ name
          ENI_CONFIG_LABEL_DEF = "topology.kubernetes.io/zone"
        }
        eniConfig = {
          create = true
          region = data.aws_region.current.region
          subnets = {
            for id, subnet in data.aws_subnet.podsubnet : subnet.availability_zone => {
              id             = id
              securityGroups = [module.eks.node_security_group_id]
            }
          }
        }
      })
    }
  }

  # Fargate profile for Karpenter controller
  # Only Karpenter controller runs on Fargate; all other workloads run on Karpenter-provisioned nodes
  fargate_profiles = {
    karpenter = {
      selectors = [
        {
          namespace = "karpenter"
        }
      ]
      subnet_ids = data.aws_subnets.private.ids
    }
  }

  node_security_group_tags = {
    "karpenter.sh/discovery"                     = var.cluster_name
    "karpenter.sh/discovery/${var.cluster_name}" = "1" # For Karpenter to discover node security group
  }

  # kms_key_administrators = [§
  #   tolist(data.aws_iam_roles.sso_administrators.arns)[0],
  #   "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/GitHubActions"
  # ]
}
