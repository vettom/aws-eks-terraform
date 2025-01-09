# # IAM policy to enable DNS record creation and lookup
# resource "aws_iam_policy" "certmanager_iam_policy" {
#   name = "CertManagerIAMPolicy"
#   policy = jsonencode(
#     {
#       "Version" : "2012-10-17",
#       "Statement" : [
#         {
#           "Sid" : "VisualEditor0",
#           "Effect" : "Allow",
#           "Action" : "route53:GetChange",
#           "Resource" : "arn:aws:route53:::change/*"
#         },
#         {
#           "Sid" : "VisualEditor1",
#           "Effect" : "Allow",
#           "Action" : [
#             "route53:ListHostedZones",
#             "route53:ListHostedZonesByName"
#           ],
#           "Resource" : "*"
#         },
#         {
#           "Sid" : "VisualEditor2",
#           "Effect" : "Allow",
#           "Action" : "route53:ListResourceRecordSets",
#           "Resource" : "arn:aws:route53:::hostedzone/*"
#         },
#         {
#           "Sid" : "VisualEditor3",
#           "Effect" : "Allow",
#           "Action" : "route53:ChangeResourceRecordSets",
#           "Resource" : "arn:aws:route53:::hostedzone/*"
#         }
#       ]
#     }
#   )
# }
# # IAM role for cert manager 
# resource "aws_iam_role" "certmanager_iam_role" {
#   name               = "cert-manager-iam-role"
#   assume_role_policy = data.aws_iam_policy_document.podidentity.json
# }
# # Attach policy to IAM role
# resource "aws_iam_role_policy_attachment" "certmanager_policy_attachement" {
#   role       = aws_iam_role.certmanager_iam_role.name
#   policy_arn = aws_iam_policy.certmanager_iam_policy.arn
# }
# # Associate Pod identity with IAM role
# resource "aws_eks_pod_identity_association" "certmanager" {
#   cluster_name    = module.eks.cluster_name
#   namespace       = "cert-manager"
#   service_account = "cert-manager"
#   role_arn        = aws_iam_role.certmanager_iam_role.arn
# }