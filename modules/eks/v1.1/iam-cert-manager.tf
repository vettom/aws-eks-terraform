locals {
  certmanager_serviceaccount = "cert-manager-${var.cluster_name}"
  certmanager_namespace      = "cert-manager"
}

data "aws_iam_policy_document" "certmanager_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(module.eks.oidc_provider, "https://", "")}:sub"
      values   = ["system:serviceaccount:${local.certmanager_namespace}:${local.certmanager_serviceaccount}"]
    }

    principals {
      identifiers = [module.eks.oidc_provider_arn]
      type        = "Federated"
    }
  }
}

#tfsec:ignore:aws-iam-no-policy-wildcards
resource "aws_iam_policy" "certmanager_iam_policy" {
  name = "CertManagerIAMPolicy-${var.cluster_name}"
  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Sid" : "VisualEditor0",
          "Effect" : "Allow",
          "Action" : "route53:GetChange",
          "Resource" : "arn:aws:route53:::change/*"
        },
        {
          "Sid" : "VisualEditor1",
          "Effect" : "Allow",
          "Action" : [
            "route53:ListHostedZones",
            "route53:ListHostedZonesByName"
          ],
          "Resource" : "*"
        },
        {
          "Sid" : "VisualEditor2",
          "Effect" : "Allow",
          "Action" : "route53:ListResourceRecordSets",
          "Resource" : "arn:aws:route53:::hostedzone/*"
        },
        {
          "Sid" : "VisualEditor3",
          "Effect" : "Allow",
          "Action" : "route53:ChangeResourceRecordSets",
          "Resource" : "arn:aws:route53:::hostedzone/*"
        }
      ]
    }
  )
}

resource "aws_iam_role" "certmanager_iam_role" {
  name               = local.certmanager_serviceaccount
  assume_role_policy = data.aws_iam_policy_document.certmanager_assume_role_policy.json
}

resource "aws_iam_role_policy_attachment" "certmanager_policy_attachement" {
  role       = aws_iam_role.certmanager_iam_role.name
  policy_arn = aws_iam_policy.certmanager_iam_policy.arn
}