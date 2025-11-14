locals {
  thanos_s3_buckets = [
    "${aws_s3_bucket.thanos-storage.arn}",
    "${aws_s3_bucket.thanos-storage.arn}/*"
  ]
}

resource "aws_iam_policy" "prometheus-thanos" {
  name        = "prometheus-thanos-policy"
  description = "Policy for Thanos sidecar to access S3 storage"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "ThanosStorage",
        "Effect" : "Allow",
        "Action" : [
          "s3:ListBucket",
          "s3:PutObject",
          "s3:GetObject",
          "s3:DeleteObject"
        ],
        "Resource" : local.thanos_s3_buckets
      }
    ]
  })
}

resource "aws_iam_role" "prometheus-thanos" {
  name               = "prometheus-thanos-role"
  assume_role_policy = data.aws_iam_policy_document.pod_id_assume_role.json
}

resource "aws_iam_role_policy_attachment" "prometheus-thanos" {
  role       = aws_iam_role.prometheus-thanos.name
  policy_arn = aws_iam_policy.prometheus-thanos.arn
}

resource "aws_eks_pod_identity_association" "prometheus-thanos" {
  cluster_name    = module.eks.cluster_name
  namespace       = "monitoring"
  service_account = "kube-prometheus-stack-prometheus"
  role_arn        = aws_iam_role.prometheus-thanos.arn
}

resource "aws_eks_pod_identity_association" "thanos-receive" {
  cluster_name    = module.eks.cluster_name
  namespace       = "thanos"
  service_account = "thanos-receive"
  role_arn        = aws_iam_role.prometheus-thanos.arn
}

resource "aws_eks_pod_identity_association" "thanos-compactor" {
  cluster_name    = module.eks.cluster_name
  namespace       = "thanos"
  service_account = "thanos-compactor"
  role_arn        = aws_iam_role.prometheus-thanos.arn
}

resource "aws_eks_pod_identity_association" "thanos-storegateway" {
  cluster_name    = module.eks.cluster_name
  namespace       = "thanos"
  service_account = "thanos-storegateway"
  role_arn        = aws_iam_role.prometheus-thanos.arn
}

resource "aws_eks_pod_identity_association" "thanos-query" {
  cluster_name    = module.eks.cluster_name
  namespace       = "thanos"
  service_account = "thanos-query"
  role_arn        = aws_iam_role.prometheus-thanos.arn
}
