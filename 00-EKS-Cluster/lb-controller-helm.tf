# Get current AWS account ID for SA annotation
data "aws_caller_identity" "current" {}

# Use Helm to install LB controller.
resource "helm_release" "aws-load-balancer-controller" {
  name       = "aws-load-balancer-controller"
  namespace  = "kube-system"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  version    = "1.7.2"

  set {
    name  = "clusterName"
    value = module.eks.cluster_name
  }

  set {
    name  = "defaultTargetType"
    value = "ip"
  }

  set {
    name  = "serviceAccount.create"
    value = "true"
  }

  set {
    name  = "serviceAccount.name"
    value = "aws-load-balancer-controller-${module.eks.cluster_name}"
  }
  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com\\/role-arn"
    value = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role\\/aws-load-balancer-controller-${module.eks.cluster_name}"
  }
}
