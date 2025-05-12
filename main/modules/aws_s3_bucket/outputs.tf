#module/aws_s3_bucket/outputs.tf

output "bucket_arn" {
  value = aws_s3_bucket.example.arn
}

output "bucket_id" {
  value = aws_s3_bucket.example.id
}