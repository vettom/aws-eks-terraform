output "s3files_bucket_name" {
  description = "S3 bucket name for S3 Files"
  value       = aws_s3_bucket.s3filesstore.id
}

output "s3files_file_system_id" {
  description = "S3 Filesystem ID"
  value       = aws_s3files_file_system.s3filesstore.id
}

output "s3files_access_point_demoapp" {
  description = "S3 Filesystem Access Point ID"
  value       = aws_s3files_access_point.demoapp.id
}
