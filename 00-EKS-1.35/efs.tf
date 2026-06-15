# resource "aws_security_group" "efs" {
#   name        = "efs-${module.eks.cluster_name}"
#   description = "Allow NFS from EKS nodes to EFS"
#   vpc_id      = module.vpc.vpc_id

#   ingress {
#     from_port       = 2049
#     to_port         = 2049
#     protocol        = "tcp"
#     security_groups = [module.eks.node_security_group_id]
#   }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
# }

# resource "aws_efs_file_system" "this" {
#   creation_token   = module.eks.cluster_name
#   encrypted        = true
#   performance_mode = "generalPurpose"
#   throughput_mode  = "bursting"

#   tags = {
#     Name = "efs-${module.eks.cluster_name}"
#   }
# }

# resource "aws_efs_mount_target" "this" {
#   count           = length(module.vpc.private_subnets)
#   file_system_id  = aws_efs_file_system.this.id
#   subnet_id       = module.vpc.private_subnets[count.index]
#   security_groups = [aws_security_group.efs.id]
# }
