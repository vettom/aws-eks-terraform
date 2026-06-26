
locals {
  # From the role prefix identify full name of the role as it can potentially change.
  devOpsRole_arn = one(data.aws_iam_roles.roles.arns)
}