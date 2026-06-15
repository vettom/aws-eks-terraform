data "aws_iam_policy_document" "s3_files_assume_role" {
  statement {
    sid     = "AllowS3FilesAssumeRole"
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["elasticfilesystem.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "aws:SourceAccount"
      values   = [data.aws_caller_identity.current.account_id]
    }

    condition {
      test     = "ArnLike"
      variable = "aws:SourceArn"
      values   = ["arn:aws:s3files:${data.aws_region.current.region}:${data.aws_caller_identity.current.account_id}:file-system/*"]
    }
  }
}

resource "aws_iam_role" "s3_files" {
  name               = "s3-files-${module.eks.cluster_name}"
  assume_role_policy = data.aws_iam_policy_document.s3_files_assume_role.json
}

data "aws_iam_policy_document" "s3_files_bucket_access" {
  statement {
    sid    = "S3BucketPermissions"
    effect = "Allow"
    actions = [
      "s3:ListBucket",
      "s3:ListBucketVersions",
    ]
    resources = [aws_s3_bucket.s3filesstore.arn]
    condition {
      test     = "StringEquals"
      variable = "aws:ResourceAccount"
      values   = [data.aws_caller_identity.current.account_id]
    }
  }

  statement {
    sid    = "S3ObjectPermissions"
    effect = "Allow"
    actions = [
      "s3:AbortMultipartUpload",
      "s3:DeleteObject*",
      "s3:GetObject*",
      "s3:List*",
      "s3:PutObject*",
    ]
    resources = ["${aws_s3_bucket.s3filesstore.arn}/*"]
    condition {
      test     = "StringEquals"
      variable = "aws:ResourceAccount"
      values   = [data.aws_caller_identity.current.account_id]
    }
  }

  statement {
    sid    = "EventBridgeManage"
    effect = "Allow"
    actions = [
      "events:DeleteRule",
      "events:DisableRule",
      "events:EnableRule",
      "events:PutRule",
      "events:PutTargets",
      "events:RemoveTargets",
    ]
    resources = ["arn:aws:events:*:*:rule/DO-NOT-DELETE-S3-Files*"]
    condition {
      test     = "StringEquals"
      variable = "events:ManagedBy"
      values   = ["elasticfilesystem.amazonaws.com"]
    }
  }

  statement {
    sid    = "EventBridgeRead"
    effect = "Allow"
    actions = [
      "events:DescribeRule",
      "events:ListRuleNamesByTarget",
      "events:ListRules",
      "events:ListTargetsByRule",
    ]
    resources = ["arn:aws:events:*:*:rule/*"]
  }
}

resource "aws_iam_role_policy" "s3_files_bucket_access" {
  name   = "s3-files-bucket-access"
  role   = aws_iam_role.s3_files.name
  policy = data.aws_iam_policy_document.s3_files_bucket_access.json
}
