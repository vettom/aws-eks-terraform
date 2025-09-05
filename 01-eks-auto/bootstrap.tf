resource "helm_release" "bootstrap" {
  name  = "bootstrap"
  chart = "./charts/bootstrap"

}
