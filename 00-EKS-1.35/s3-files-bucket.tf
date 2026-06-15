resource "aws_s3_bucket" "s3filesstore" {
  bucket = "s3filesstore-${module.eks.cluster_name}"

  tags = {
    Name        = "s3filesstore-${module.eks.cluster_name}"
    Environment = "test"
    Terraform   = "true"
  }
}

resource "aws_s3_bucket_public_access_block" "s3filesstore" {
  bucket = aws_s3_bucket.s3filesstore.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Versioning must be enabled on the bucket for S3 Files to work
resource "aws_s3_bucket_versioning" "s3filesstore" {
  bucket = aws_s3_bucket.s3filesstore.id
  versioning_configuration {
    status = "Enabled"
  }
}

# In order to save storage costs, delete versions older than 7 days
resource "aws_s3_bucket_lifecycle_configuration" "s3filesstore" {
  bucket = aws_s3_bucket.s3filesstore.id

  rule {
    id     = "expire-noncurrent-versions"
    status = "Enabled"

    noncurrent_version_expiration {
      noncurrent_days = 7
    }
  }
}

resource "aws_s3files_file_system" "s3filesstore" {
  bucket   = aws_s3_bucket.s3filesstore.arn
  role_arn = aws_iam_role.s3_files.arn

  tags = {
    Name        = "s3filesstore-${module.eks.cluster_name}"
    Environment = "test"
    Terraform   = "true"
  }
}

resource "aws_security_group" "s3files" {
  name        = "s3files-${module.eks.cluster_name}"
  description = "Allow NFS from EKS nodes to S3 Files"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port       = 2049
    to_port         = 2049
    protocol        = "tcp"
    security_groups = [module.eks.node_security_group_id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_s3files_mount_target" "s3filesstore" {
  count           = length(module.vpc.private_subnets)
  file_system_id  = aws_s3files_file_system.s3filesstore.id
  subnet_id       = module.vpc.private_subnets[count.index]
  security_groups = [aws_security_group.s3files.id]
}


resource "aws_s3_object" "demoapp" {
  bucket  = aws_s3_bucket.s3filesstore.id
  key     = "demoapp/"
  content = ""
}

resource "aws_s3files_access_point" "demoapp" {
  file_system_id = aws_s3files_file_system.s3filesstore.id

  # posix_user {
  #   gid = 1001
  #   uid = 1001
  # }
  root_directory {
    path = "/demoapp"
  }
}
