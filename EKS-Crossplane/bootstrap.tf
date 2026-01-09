resource "helm_release" "bootstrap" {
  name  = "bootstrap"
  chart = "./helm/bootstrap"
}
