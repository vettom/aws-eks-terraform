resource "aws_iam_role" "ack-iam-controller" {
  name               = "ack-iam-controller"
  assume_role_policy = data.aws_iam_policy_document.pod_id_assume_role.json
}

resource "aws_iam_policy" "ack-iam-controller" {
  name        = "ack-iam-controller-policy"
  description = "Policy for ACK IAM Controller"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "AllowRoleCreation",
        "Effect" : "Allow",
        "Action" : [
          "iam:CreateRole",
          "iam:TagRole",
          "iam:PassRole",
          "iam:UpdateAssumeRolePolicy",
          "iam:GetRole",
          "iam:ListRolePolicies",
          "iam:PutRolePolicy",
          "iam:DeleteRole",
          "iam:DeleteRolePolicy",
          "iam:ListRoles",
          "iam:ListRoleTags",
          "iam:AttachRolePolicy",
          "iam:DetachRolePolicy",
          "iam:ListAttachedRolePolicies",
          "iam:ListPolicies",
          "iam:GetPolicy",
          "iam:GetPolicyVersion",
          "iam:CreatePolicyVersion",
          "iam:DeletePolicyVersion",
          "iam:SetDefaultPolicyVersion",
          "iam:CreatePolicy",
          "iam:DeletePolicy",
          "iam:GetPolicy",
          "iam:GetPolicyVersion",
          "iam:ListPolicyVersions",
          "iam:SetDefaultPolicyVersion",
          "iam:TagPolicy",
          "iam:UntagPolicy"
        ],
        "Resource" : "*"
      },

      {
        "Sid" : "DenyAdministratorAccessAttachment",
        "Effect" : "Deny",
        "Action" : [
          "iam:AttachRolePolicy",
          "iam:DetachRolePolicy"
        ],
        "Resource" : "arn:aws:iam::aws:policy/AdministratorAccess"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ack-iam-controller" {
  role       = aws_iam_role.ack-iam-controller.name
  policy_arn = aws_iam_policy.ack-iam-controller.arn
}

resource "aws_eks_pod_identity_association" "ack-iam-controller" {
  cluster_name    = module.eks.cluster_name
  namespace       = "ack-system"
  service_account = "ack-iam-controller"
  role_arn        = aws_iam_role.ack-iam-controller.arn
}
