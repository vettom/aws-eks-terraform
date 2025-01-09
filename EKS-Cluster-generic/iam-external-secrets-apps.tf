locals {
  appsSecrets_serviceaccount = "apps-secrets"
  appsSecrets_namespace     = "kube-system"
}

data "aws_iam_policy_document" "appsSecrets_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(module.eks.oidc_provider, "https://", "")}:sub"
      values   = ["system:serviceaccount:${local.appsSecrets_namespace}:${local.appsSecrets_serviceaccount}"]
    }

    principals {
      identifiers = [module.eks.oidc_provider_arn]
      type        = "Federated"
    }

  }
}

resource "aws_iam_role" "appsSecrets_iam_role" {
  name               = local.appsSecrets_serviceaccount
  assume_role_policy = data.aws_iam_policy_document.appsSecrets_assume_role_policy.json
}

#tfsec:ignore:aws-iam-no-policy-wildcards
resource "aws_iam_policy" "appsSecrets_read_secrets" {
  name = "appssecrets-readonly"
  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Sid" : "VisualEditor0",
          "Effect" : "Allow",
          "Action" : [
            "secretsmanager:GetRandomPassword",
            "secretsmanager:GetResourcePolicy",
            "secretsmanager:GetSecretValue",
            "secretsmanager:DescribeSecret",
            "secretsmanager:ListSecretVersionIds",
            "secretsmanager:ListSecrets",
            "secretsmanager:BatchGetSecretValue"
          ],
          "Resource" : "arn:aws:secretsmanager:${data.aws_region.current.id}:${data.aws_caller_identity.current.account_id}:secret:apps/*"
        }
      ]
    }
  )
}

resource "aws_iam_role_policy_attachment" "appsSecrets_policy_attachement" {
  role       = aws_iam_role.appsSecrets_iam_role.name
  policy_arn = aws_iam_policy.appsSecrets_read_secrets.arn

}
