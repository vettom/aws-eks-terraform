resource "aws_eks_access_entry" "aws_eks_access_entry" {
  cluster_name  = aws_eks_cluster.eks-auto-demo.name
  principal_arn = data.aws_caller_identity.current.arn
  type          = "STANDARD"
}

resource "aws_eks_access_policy_association" "aws_eks_access_policy_association" {
  cluster_name  = aws_eks_cluster.eks-auto-demo.name
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
  principal_arn = data.aws_caller_identity.current.arn

  access_scope {
    type = "cluster"
    # namespaces = ["example-namespace"]
  }
}




# output "account_id" {
#   value = data.aws_caller_identity.current.account_id
# }

# output "caller_arn" {
#   value = data.aws_caller_identity.current.arn
# }

# output "caller_user" {
#   value = data.aws_caller_identity.current.user_id
# }