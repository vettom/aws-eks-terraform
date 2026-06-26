locals {
  externalEks_servicaccount = "argocd-service-account-${var.cluster_name}"
  externalEks_namespace     = "argocd"
}

data "aws_iam_policy_document" "argocd_ecr_assume_role" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    principals {
      type        = "Federated"
      identifiers = [module.eks.oidc_provider_arn]
    }

    condition {
      test     = "StringEquals"
      variable = "${replace(module.eks.oidc_provider, "https://", "")}:sub"
      values   = ["system:serviceaccount:${local.externalEks_namespace}:${local.externalEks_servicaccount}"]
    }
  }
}

resource "aws_iam_role" "argocd_ecr" {
  name               = local.externalEks_servicaccount
  assume_role_policy = data.aws_iam_policy_document.argocd_ecr_assume_role.json
}
