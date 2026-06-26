locals {
  iam_identity_serviceaccount = "iam-identity-${var.cluster_name}"
}

resource "aws_iam_role" "iam_identity_iam_role" {
  name = local.iam_identity_serviceaccount
  assume_role_policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Principal" : {
            "Service" : "pods.eks.amazonaws.com"
          },
          "Action" : [
            "sts:AssumeRole",
            "sts:TagSession"
          ]
        }
      ]
    }
  )
}
