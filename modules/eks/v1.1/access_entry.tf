# resource "aws_eks_access_entry" "devopsuser" {
#   cluster_name      = module.eks.cluster_name
#   principal_arn     = local.devOpsRole_arn
#   kubernetes_groups = []
#   type              = "STANDARD"
# }

# resource "aws_eks_access_policy_association" "devopsreadpolicy" {
#   #   If admin is false, create readonly (default)
#   count         = var.enable_cluster_admin ? 0 : 1
#   cluster_name  = module.eks.cluster_name
#   policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSAdminViewPolicy"
#   principal_arn = local.devOpsRole_arn
#   access_scope {
#     type = "cluster"
#   }
# }

# resource "aws_eks_access_policy_association" "devopsadminpolicy" {
#   count         = var.enable_cluster_admin ? 1 : 0
#   cluster_name  = module.eks.cluster_name
#   policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
#   principal_arn = local.devOpsRole_arn
#   access_scope {
#     type = "cluster"
#   }
# }
