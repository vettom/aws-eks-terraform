resource "aws_s3_bucket" "thanos-storage" {
  bucket = "${module.eks.cluster_name}-thanos"

}
