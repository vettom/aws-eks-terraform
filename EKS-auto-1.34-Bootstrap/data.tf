# Trust policy for Pod Identity service
data "aws_iam_policy_document" "podidentity" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["pods.eks.amazonaws.com"]
    }

    actions = [
      "sts:AssumeRole",
      "sts:TagSession"
    ]
  }
}
data "aws_caller_identity" "current" {}
data "aws_region" "current" {}