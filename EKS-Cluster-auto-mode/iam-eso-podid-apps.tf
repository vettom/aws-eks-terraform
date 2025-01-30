resource "aws_iam_role" "ekseso_iam_role" {
  name               = "external-secrets"
  assume_role_policy = data.aws_iam_policy_document.podidentity.json
}

resource "aws_eks_pod_identity_association" "ekseso" {
  cluster_name    = aws_eks_cluster.eks-auto-demo.name
  namespace       = "externalsecrets"
  service_account = "external-secrets"
  role_arn        = aws_iam_role.ekseso_iam_role.arn
}

resource "aws_iam_policy" "ekseso_iam_policy" {
  name = "esoControllerIAMPolicy"
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
            "arn:aws:secretsmanager:${data.aws_region.current.id}:${data.aws_caller_identity.current.account_id}:secret:eks/*"
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
            "arn:aws:secretsmanager:${data.aws_region.current.id}:${data.aws_caller_identity.current.account_id}:secret:eks/*"
          ]
        }
      ]
    }
  )
}

resource "aws_iam_role_policy_attachment" "ekseso_policy_attachment" {
  role       = aws_iam_role.ekseso_iam_role.name
  policy_arn = aws_iam_policy.ekseso_iam_policy.arn
}