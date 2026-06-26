
# resource "aws_iam_role" "efs_csi_controller" {
#   name               = "efs-csi-controller-${module.eks.cluster_name}"
#   assume_role_policy = data.aws_iam_policy_document.pod_id_assume_role.json
# }

# resource "aws_iam_role_policy_attachment" "efs_csi_driver_policy" {
#   role       = aws_iam_role.efs_csi_controller.name
#   policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEFSCSIDriverPolicy"
# }

# resource "aws_iam_role_policy_attachment" "s3_files_csi_driver_policy" {
#   role       = aws_iam_role.efs_csi_controller.name
#   policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonS3FilesCSIDriverPolicy"
# }

# resource "aws_iam_role_policy_attachment" "efs_filesystem_utils" {
#   role       = aws_iam_role.efs_csi_controller.name
#   policy_arn = "arn:aws:iam::aws:policy/AmazonElasticFileSystemsUtils"
# }

# resource "aws_iam_role_policy_attachment" "efs_csi_s3_client_full_access" {
#   role       = aws_iam_role.efs_csi_controller.name
#   policy_arn = "arn:aws:iam::aws:policy/AmazonS3FilesClientFullAccess"
# }

# data "aws_iam_policy_document" "efs_client_mount" {
#   statement {
#     effect    = "Allow"
#     actions   = ["elasticfilesystem:ClientMount"]
#     resources = ["*"]
#   }
# }

# resource "aws_iam_role_policy" "efs_client_mount" {
#   name   = "efs-client-mount"
#   role   = aws_iam_role.efs_csi_controller.name
#   policy = data.aws_iam_policy_document.efs_client_mount.json
# }

# resource "aws_eks_pod_identity_association" "efs_csi_controller" {
#   cluster_name    = module.eks.cluster_name
#   namespace       = "kube-system"
#   service_account = "efs-csi-controller-sa"
#   role_arn        = aws_iam_role.efs_csi_controller.arn
# }

# resource "aws_eks_pod_identity_association" "efs_csi_node" {
#   cluster_name    = module.eks.cluster_name
#   namespace       = "kube-system"
#   service_account = "efs-csi-node-sa"
#   role_arn        = aws_iam_role.efs_csi_controller.arn
# }
