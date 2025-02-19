resource "aws_eks_addon" "vpc-cni" {
  cluster_name  = module.eks.cluster_name
  addon_name    = "vpc-cni"
  addon_version = "v1.18.5-eksbuild.1"
  configuration_values = jsonencode(
    {
      env = {

        ENABLE_PREFIX_DELEGATION          = "true" # Required for ALB to work with target type ip
        WARM_ENI_TARGET                   = "1"    # optional prefix IP pool.
        WARM_PREFIX_TARGET                = "1"
        POD_SECURITY_GROUP_ENFORCING_MODE = "standard"
        AWS_VPC_K8S_CNI_EXTERNALSNAT      = "true" # Optional when using SG for pod outbound traffic routing.
        ENABLE_POD_ENI                    = "true" # If using Security group for pods

      }
      enableNetworkPolicy = "true"
    }
  )
}
