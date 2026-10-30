# IRSA assume role policy document for Karpenter controller running on Fargate
# Fargate does not support EKS Pod Identity DaemonSet, so IRSA is required
data "aws_iam_policy_document" "karpenter_controller_assume_role" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(module.eks.oidc_provider, "https://", "")}:sub"
      values   = ["system:serviceaccount:karpenter:karpenter"]
    }

    condition {
      test     = "StringEquals"
      variable = "${replace(module.eks.oidc_provider, "https://", "")}:aud"
      values   = ["sts.amazonaws.com"]
    }

    principals {
      identifiers = [module.eks.oidc_provider_arn]
      type        = "Federated"
    }
  }
}

# Karpenter IAM Roles, Access Entry, SQS Interruption Queue & EventBridge Rules
module "karpenter" {
  source  = "terraform-aws-modules/eks/aws//modules/karpenter"
  version = "~> 21.21"

  cluster_name = module.eks.cluster_name

  # Enable IRSA assume role policy for controller on Fargate
  iam_role_source_assume_policy_documents = [data.aws_iam_policy_document.karpenter_controller_assume_role.json]
  create_pod_identity_association         = false

  # Enable native Spot termination handling via SQS and EventBridge
  enable_spot_termination = true

  # Attach additional IAM policies to the Karpenter node IAM role
  node_iam_role_additional_policies = {
    AmazonSSMManagedInstanceCore = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  }

  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}

# Deploy Karpenter CRDs via Helm
resource "helm_release" "karpenter_crd" {
  name             = "karpenter-crd"
  namespace        = "karpenter"
  create_namespace = true
  repository       = "oci://public.ecr.aws/karpenter"
  chart            = "karpenter-crd"
  version          = var.karpenter_version

  depends_on = [
    module.eks.fargate_profiles
  ]
}

# Deploy Karpenter Controller onto Fargate
resource "helm_release" "karpenter" {
  name             = "karpenter"
  namespace        = "karpenter"
  create_namespace = true
  repository       = "oci://public.ecr.aws/karpenter"
  chart            = "karpenter"
  version          = var.karpenter_version

  values = [
    yamlencode({
      replicas : 1
      serviceAccount = {
        name = "karpenter"
        annotations = {
          "eks.amazonaws.com/role-arn" = module.karpenter.iam_role_arn
        }
      }
      settings = {
        clusterName       = module.eks.cluster_name
        clusterEndpoint   = module.eks.cluster_endpoint
        interruptionQueue = module.karpenter.queue_name
      }
      controller = {
        resources = {
          requests = {
            cpu    = "300m"
            memory = "512Mi"
          }
          limits = {
            cpu    = "300m"
            memory = "512Mi"
          }
        }
      }
      nodeSelector = {
        "kubernetes.io/os" = "linux"
      }
      # CRITICAL FOR FARGATE:
      # Karpenter must resolve AWS APIs (STS, EC2) using VPC DNS directly.
      # If left to default ClusterFirst, it cannot resolve APIs before CoreDNS is running.
      dnsPolicy = "Default"
    })
  ]

  depends_on = [
    helm_release.karpenter_crd,
    module.eks.fargate_profiles
  ]
}

# Deploy Karpenter NodePool and EC2NodeClass to provision SPOT worker nodes
resource "helm_release" "karpenter_nodepool" {
  name      = "karpenter-nodepool"
  chart     = "${path.module}/helm/nodepool"
  namespace = "karpenter"

  values = [
    yamlencode({
      clusterName = module.eks.cluster_name
      nodeRole    = module.karpenter.node_iam_role_name
    })
  ]

  depends_on = [
    helm_release.karpenter
  ]
}
