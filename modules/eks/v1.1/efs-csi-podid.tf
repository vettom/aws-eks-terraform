# resource "aws_iam_policy" "aws-efs-csi-driver" {
#   name        = "efs-csi-driver-policy-${var.cluster_name}"
#   description = "Policy for EFS CSI Controller"

#   policy = jsonencode({
#     "Version" : "2012-10-17",
#     "Statement" : [
#       {
#         "Sid" : "LokiStorage",
#         "Effect" : "Allow",
#         "Action" : [
#           "s3:ListBucket",
#           "s3:PutObject",
#           "s3:GetObject",
#           "s3:DeleteObject"
#         ],
#         "Resource" : local.loki_s3_buckets
#       }
#     ]
#   })
# }

# resource "aws_iam_role" "aws-efs-csi-driver" {
#   name               = "efs-csi-controller-${var.cluster_name}"
#   assume_role_policy = data.aws_iam_policy_document.pod_id_assume_role.json
# }

# resource "aws_iam_role_policy_attachment" "aws-efs-csi-driver" {
#   role       = aws_iam_role.aws-efs-csi-driver.name
#   policy_arn = aws_iam_policy.aws-efs-csi-driver.arn
# }

# resource "aws_eks_pod_identity_association" "aws-efs-csi-driver" {
#   cluster_name    = module.eks.cluster_name
#   namespace       = "loki"
#   service_account = "loki"
#   role_arn        = aws_iam_role.aws-efs-csi-driver.arn
# }
