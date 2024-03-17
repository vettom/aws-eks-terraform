resource "aws_eks_addon" "vpc-cni" {
  cluster_name  = module.eks.cluster_name
  addon_name    = "vpc-cni"
  addon_version = var.cni_addon_version
  configuration_values = jsonencode(
    {
      env = {
        ENABLE_POD_ENI                    = "true"
        ENABLE_PREFIX_DELEGATION          = "true"
        POD_SECURITY_GROUP_ENFORCING_MODE = "standard"
        AWS_VPC_K8S_CNI_EXTERNALSNAT      = "true"
        WARM_ENI_TARGET                   = "2"
        WARM_PREFIX_TARGET                = "2"
      }
      enableNetworkPolicy = "true"
    }
  )
}
resource "aws_eks_addon" "eks-pod-identity-agent" {
  cluster_name  = module.eks.cluster_name
  addon_name    = "eks-pod-identity-agent"
  addon_version = var.pod_identity_addon_version
}
