module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.21"

  name               = var.cluster_name
  kubernetes_version = var.kubernetes_version

  vpc_id                                   = data.aws_vpc.this.id
  subnet_ids                               = data.aws_subnets.private.ids
  authentication_mode                      = "API"
  enable_cluster_creator_admin_permissions = var.enable_cluster_creator_admin_permissions
  endpoint_public_access                   = var.enable_endpoint_public_access
  endpoint_public_access_cidrs             = var.endpoint_public_access_cidrs

  compute_config = {
    enabled = false
  }
  # Create just the IAM resources for EKS Auto Mode for use with custom node pools
  create_auto_mode_iam_resources = true

  # Disable cloudwatch logging for EKS
  enabled_log_types                      = var.cloudwatch_enabled_log_types
  cloudwatch_log_group_retention_in_days = var.cloudwatch_log_group_retention_in_days

  addons = {
    vpc-cni = {
      before_compute = true
      addon_version  = var.vpc_cni_version

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
          create = var.create_eniconfig
          region = data.aws_region.current.region
          subnets = {
            for id, subnet in data.aws_subnet.pod_subnet : subnet.availability_zone => {
              id             = id
              securityGroups = [module.eks.node_security_group_id]
            }
          }
        }
      })
    }
  }

  eks_managed_node_groups = {
    eks_nodegroup_1 = {
      ami_type       = "BOTTLEROCKET_x86_64"
      min_size       = var.node_min_size
      max_size       = var.node_max_size
      desired_size   = var.node_desired_size
      instance_types = var.node_instance_type
      capacity_type  = var.node_capacity_type

      iam_role_additional_policies = {
        SSMAccess = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
      }

      block_device_mappings = {
        xvda = {
          device_name = "/dev/xvda"
          ebs = {
            volume_size           = 2
            volume_type           = "gp3"
            encrypted             = true
            delete_on_termination = true
          }
        }
        xvdb = {
          device_name = "/dev/xvdb"
          ebs = {
            volume_size           = var.node_volume_size
            volume_type           = "gp3"
            encrypted             = true
            delete_on_termination = true
          }
        }
      }
    }
  }

  node_security_group_tags = {
    "karpenter.sh/discovery/${var.cluster_name}" = "1" # For Karpenter to make use of same Security group created by module
  }

  # kms_key_administrators = [
  #   tolist(data.aws_iam_roles.sso_administrators.arns)[0]
  # ]
}
