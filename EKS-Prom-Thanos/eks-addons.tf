resource "aws_eks_addon" "ebs-csi" {
  cluster_name  = module.eks.cluster_name
  addon_name    = "aws-ebs-csi-driver"
  addon_version = "v1.52.1-eksbuild.1"
  # resolve_conflicts_on_create = "OVERWRITE"
}

