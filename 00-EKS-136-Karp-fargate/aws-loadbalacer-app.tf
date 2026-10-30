# Ingress is not used on this platform - IngressClass creation is disabled.
# Gateway API traffic routing is handled by Envoy Gateway, not by this controller's
resource "helm_release" "aws_load_balancer_controller" {
  name       = "aws-load-balancer-controller"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  version    = "3.6.2"
  namespace  = "kube-system"

  values = [
    yamlencode({
      clusterName       = module.eks.cluster_name
      vpcId             = data.aws_vpc.this.id
      defaultTargetType = "ip"
      #   hostNetwork       = "true" # only when custom CNI used

      serviceAccount = {
        create = true
        name   = "aws-load-balancer-controller"
      }

      createIngressClassResource = false
    })
  ]

  depends_on = [
    module.eks,
    aws_eks_pod_identity_association.aws_load_balancer_controller,
    helm_release.karpenter_nodepool,
    aws_eks_addon.coredns,
  ]
}
