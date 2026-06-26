locals {
  externaldns_serviceaccount = "external-dns-controller-${var.cluster_name}"
  externaldns_namepsace      = "external-dns"
}

data "aws_iam_policy_document" "external-dns_controller_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(module.eks.oidc_provider, "https://", "")}:sub"
      values   = ["system:serviceaccount:${local.externaldns_namepsace}:${local.externaldns_serviceaccount}"]
    }

    principals {
      identifiers = [module.eks.oidc_provider_arn]
      type        = "Federated"
    }
  }
}

#tfsec:ignore:aws-iam-no-policy-wildcards
resource "aws_iam_policy" "external_dns_iam_policy" {
  name = "ExternalDNSControllerIAMPolicy-${var.cluster_name}"
  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Action" : [
            "route53:ChangeResourceRecordSets"
          ],
          "Resource" : [
            "arn:aws:route53:::hostedzone/*"
          ]
        },
        {
          "Effect" : "Allow",
          "Action" : [
            "route53:ListHostedZones",
            "route53:ListResourceRecordSets"
          ],
          "Resource" : [
            "*"
          ]
        }
      ]
    }
  )
}

resource "aws_iam_role" "externaldns_iam_role" {
  name               = local.externaldns_serviceaccount
  assume_role_policy = data.aws_iam_policy_document.external-dns_controller_assume_role_policy.json
}

resource "aws_iam_role_policy_attachment" "externaldns_policy_attachement" {
  role       = aws_iam_role.externaldns_iam_role.name
  policy_arn = aws_iam_policy.external_dns_iam_policy.arn
}