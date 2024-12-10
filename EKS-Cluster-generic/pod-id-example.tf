# resource "aws_iam_role" "example" {
#   name               = "eks-pod-identity-example"
#   assume_role_policy = data.aws_iam_policy_document.podidentity.json
# }

# resource "aws_iam_role_policy_attachment" "example_s3" {
#   policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess" # Full S3 read only access.
#   role       = aws_iam_role.example.name
# }

# # Pods running in example namespace with "exampleservieaccount" are permitted to use this role
# resource "aws_eks_pod_identity_association" "example" {
#   cluster_name    = module.eks.cluster_name
#   namespace       = "example"
#   service_account = "exampleserviceaccount"
#   role_arn        = aws_iam_role.example.arn
# }