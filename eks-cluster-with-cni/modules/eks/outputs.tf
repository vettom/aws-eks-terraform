resource "aws_ssm_parameter" "cluster_endpoint" {
  name  = "/${var.cluster_name}/cluster_endpoint"
  type  = "String"
  value = module.eks.cluster_endpoint
}

resource "aws_ssm_parameter" "node_security_group_id" {
  name  = "/${var.cluster_name}/node_security_group_id"
  type  = "String"
  value = module.eks.node_security_group_id
}

resource "aws_ssm_parameter" "cluster_certificate_authority_data" {
  name  = "/${var.cluster_name}/cluster_certificate_authority_data"
  type  = "String"
  value = module.eks.cluster_certificate_authority_data
}

resource "aws_ssm_parameter" "aws_load_balancer_controller_role_arn" {
  name  = "/${var.cluster_name}/aws_load_balancer_controller_role_arn"
  type  = "String"
  value = aws_iam_role.aws_load_balancer_controller.arn
}

resource "aws_ssm_parameter" "externaldns_iam_role_arn" {
  name  = "/${var.cluster_name}/externaldns_iam_role_arn"
  type  = "String"
  value = aws_iam_role.externaldns_iam_role.arn
}

output "cluster_name" {
  value       = module.eks.cluster_name
  description = "Name of EKS Cluster"
}
output "cluster_endpoint" {
  value       = module.eks.cluster_endpoint
  description = "EKS Endpoint URL"
}
output "cluster_certificate_authority_data" {
  value       = module.eks.cluster_certificate_authority_data
  description = "EKS cluster Certificate"
}
output "buildversion" {
  value       = var.buildversion
  description = "Build version variable."
}
