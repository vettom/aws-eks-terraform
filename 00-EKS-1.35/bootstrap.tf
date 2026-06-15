resource "helm_release" "aws_efs_csi_driver" {
  name             = "aws-efs-csi-driver"
  repository       = "https://kubernetes-sigs.github.io/aws-efs-csi-driver"
  chart            = "aws-efs-csi-driver"
  namespace        = "kube-system"
  create_namespace = false
  version          = "4.2.0"

  depends_on = [module.eks]
}

# resource "helm_release" "bootstrap" {
#   name       = "bootstrap"
#   chart      = "./helm/bootstrap"
#   depends_on = [module.eks.cluster_certificate_authority_data, module.eks.cluster_endpoint]
# }

# resource "time_sleep" "wait_30_seconds" {
#   depends_on = [helm_release.bootstrap]

#   create_duration = "60s"
# }

# resource "helm_release" "argocd" {
#   name             = "argo-cd"
#   repository       = "https://argoproj.github.io/argo-helm"
#   chart            = "argo-cd"
#   namespace        = "argocd"
#   create_namespace = true
#   depends_on       = [time_sleep.wait_30_seconds]
# }

# resource "time_sleep" "wait_for_argocd" {
#   depends_on      = [helm_release.bootstrap, helm_release.argocd]
#   create_duration = "180s"
# }

# resource "helm_release" "core-apps" {
#   name   = "core-apps"
#   chart  = "./helm/core-apps"
#   values = [file("./helm/core-apps/values.yaml")]
# }
