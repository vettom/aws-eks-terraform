data "aws_iam_policy_document" "karpenter_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(module.eks.oidc_provider, "https://", "")}:sub"
      values   = ["system:serviceaccount:karpenter:karpenter-controller-eks-demo"]
    }

    principals {
      identifiers = [module.eks.oidc_provider_arn]
      type        = "Federated"
    }
  }
}

resource "aws_iam_role" "karpenter_controller_role" {
  assume_role_policy = data.aws_iam_policy_document.karpenter_assume_role_policy.json
  name               = "karpenter-controller-eks-demo"
}

resource "aws_iam_role_policy_attachment" "karpenter_controller_policy_attach" {
  role       = aws_iam_role.karpenter_controller_role.name
  policy_arn = aws_iam_policy.karpenter_controller_policy.arn
}


resource "aws_iam_policy" "karpenter_controller_policy" {
  name = "karpenter-controller-eks-demo"
  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Sid" : "VisualEditor0",
          "Effect" : "Allow",
          "Action" : "ec2:TerminateInstances",
          "Resource" : "arn:aws:ec2:${data.aws_region.current.id}:${data.aws_caller_identity.current.account_id}:instance/*",
          "Condition" : {
            "ForAnyValue:StringLike" : {
              "ec2:ResourceTag/Name" : "*karpenter*"
            }
          }
        },
        {
          "Sid" : "VisualEditor1",
          "Effect" : "Allow",
          "Action" : [
            "ec2:DescribeSpotPriceHistory",
            "ec2:DescribeImages",
            "ec2:DescribeInstances",
            "ec2:DescribeInstanceTypeOfferings",
            "ec2:DescribeAvailabilityZones",
            "ec2:DescribeLaunchTemplates",
            "ec2:DescribeInstanceTypes",
            "ec2:RunInstances",
            "ec2:CreateFleet",
            "ec2:DescribeSubnets",
            "ec2:DescribeSecurityGroups",
            "ec2:CreateTags",
            "pricing:GetProducts",
            "iam:GetInstanceProfile"
          ],
          "Resource" : "*"
        },
        {
          "Sid" : "VisualEditor2",
          "Effect" : "Allow",
          "Action" : [
            "ec2:DeleteLaunchTemplate",
            "ec2:CreateLaunchTemplate",
            "ec2:CreateTags"
          ],
          "Resource" : "arn:aws:ec2:${data.aws_region.current.id}:${data.aws_caller_identity.current.account_id}:launch-template/*"
        },
        {
          "Sid" : "VisualEditor3",
          "Effect" : "Allow",
          "Action" : [
            "iam:PassRole",
            "ssm:GetParameter"
          ],
          "Resource" : [
            "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/karpenter-node*",
            "arn:aws:ssm:${data.aws_region.current.id}:*:parameter/*"
          ]
        },
        {
          "Sid" : "karpenterInstanceProfile",
          "Effect" : "Allow",
          "Action" : [
            "iam:CreateInstanceProfile",
            "iam:TagInstanceProfile",
            "iam:AddRoleToInstanceProfile",
            "iam:RemoveRoleFromInstanceProfile",
            "iam:DeleteInstanceProfile"
          ],
          "Resource" : [
            "arn:aws:iam::${data.aws_caller_identity.current.account_id}:instance-profile/eks-demo*"
          ]
        }
      ]
    }
  )

}

