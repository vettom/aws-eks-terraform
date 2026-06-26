data "aws_caller_identity" "current" {}
data "aws_region" "current" {}
data "aws_iam_roles" "roles" {
  name_regex = "${var.sso_role_prefix}_.*"
}
data "aws_kms_key" "ebs" {
  key_id = "alias/aws/ebs"
}
