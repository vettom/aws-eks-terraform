resource "helm_release" "bootstrap" {
  name  = "bootstrap"
  chart = "./Helm/bootstrap"
}
