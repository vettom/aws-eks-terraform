locals {
  externalsecrets_servicaccount = "externalsecrets-${var.cluster_name}"
  externalsecrets_namespace     = "kube-system"
}

data "aws_iam_policy_document" "externalsecrets_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(module.eks.oidc_provider, "https://", "")}:sub"
      values   = ["system:serviceaccount:${local.externalsecrets_namespace}:${local.externalsecrets_servicaccount}"]
    }

    principals {
      identifiers = [module.eks.oidc_provider_arn]
      type        = "Federated"
    }

  }
}

resource "aws_iam_role" "externalsecrets_iam_role" {
  name               = local.externalsecrets_servicaccount
  assume_role_policy = data.aws_iam_policy_document.externalsecrets_assume_role_policy.json
}

#tfsec:ignore:aws-iam-no-policy-wildcards
resource "aws_iam_policy" "externalsecrets_read_secrets" {
  name = "externalsecrets-readonly-${var.cluster_name}"
  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Action" : [
            "secretsmanager:GetResourcePolicy",
            "secretsmanager:GetSecretValue",
            "secretsmanager:DescribeSecret",
            "secretsmanager:ListSecretVersionIds"
          ],
          "Resource" : [
            "arn:aws:secretsmanager:${data.aws_region.current.region}:${data.aws_caller_identity.current.account_id}:secret:eks/*",
            "arn:aws:secretsmanager:${data.aws_region.current.region}:${data.aws_caller_identity.current.account_id}:secret:rds!*"
          ]
        },
        {
          "Effect" : "Allow",
          "Action" : [
            "secretsmanager:GetRandomPassword",
            "secretsmanager:ListSecrets",
            "secretsmanager:BatchGetSecretValue"
          ],
          "Resource" : [
            "arn:aws:secretsmanager:${data.aws_region.current.region}:${data.aws_caller_identity.current.account_id}:secret:eks/*",
            "arn:aws:secretsmanager:${data.aws_region.current.region}:${data.aws_caller_identity.current.account_id}:secret:rds!*"
          ]
        }
      ]
    }
  )
}

resource "aws_iam_role_policy_attachment" "externalsecrets_policy_attachement" {
  role       = aws_iam_role.externalsecrets_iam_role.name
  policy_arn = aws_iam_policy.externalsecrets_read_secrets.arn

}
