resource "aws_iam_role" "ebs-csi-controller" {
  name               = "ebs-csi-controller-${module.eks.cluster_name}"
  assume_role_policy = data.aws_iam_policy_document.pod_id_assume_role.json
}

resource "aws_iam_role_policy_attachment" "ebscsi_policy_attachement" {
  role       = aws_iam_role.ebs-csi-controller.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"

}

resource "aws_eks_pod_identity_association" "ebs-csi-controller" {
  cluster_name    = module.eks.cluster_name
  namespace       = "kube-system"
  service_account = "ebs-csi-controller-sa"
  role_arn        = aws_iam_role.ebs-csi-controller.arn
}
