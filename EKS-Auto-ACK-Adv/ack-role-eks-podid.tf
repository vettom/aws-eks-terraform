# resource "aws_iam_role" "ack-eks-controller" {
#   name               = "ack-eks-controller"
#   assume_role_policy = data.aws_iam_policy_document.pod_id_assume_role.json
# }

# resource "aws_iam_policy" "ack-eks-controller" {
#   name        = "ack-eks-controller-policy"
#   description = "Policy for ACK IAM Controller"

#   policy = jsonencode({
#     "Version" : "2012-10-17",
#     "Statement" : [
#       {
#         "Effect" : "Allow",
#         "Action" : [
#           "eks:CreatePodIdentityAssociation",
#           "eks:DescribePodIdentityAssociation",
#           "eks:ListPodIdentityAssociations",
#           "eks:DeletePodIdentityAssociation",
#           "eks:UpdatePodIdentityAssociation",
#           "eks:TagResource",
#           "eks:UntagResource",
#           "iam:PassRole",
#           "iam:CreateRole",
#           "iam:DeleteRole",
#           "iam:AttachRolePolicy",
#           "iam:DetachRolePolicy",
#           "iam:PutRolePolicy",
#           "iam:DeleteRolePolicy",
#           "iam:GetRole",
#           "iam:ListRolePolicies",
#           "iam:ListAttachedRolePolicies",
#           "iam:ListRoles",
#         ],
#         "Resource" : "*"
#       },
#       {
#         "Effect" : "Allow",
#         "Action" : [
#           "eks:DescribeCluster"
#         ],
#         "Resource" : "*"
#       }
#     ]
#     }
#   )
# }

# resource "aws_iam_role_policy_attachment" "ack-eks-controller" {
#   role       = aws_iam_role.ack-eks-controller.name
#   policy_arn = aws_iam_policy.ack-eks-controller.arn
# }

# resource "aws_eks_pod_identity_association" "ack-eks-controller" {
#   cluster_name    = module.eks.cluster_name
#   namespace       = "ack-system"
#   service_account = "ack-eks-controller"
#   role_arn        = aws_iam_role.ack-eks-controller.arn
# }
