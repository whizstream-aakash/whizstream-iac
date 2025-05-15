#main/modules/terraform.tfvars

#S3 Bucket
aws_region                     = "us-east-1"

upload_bucket_name            = "whizstream-upload-videos"
upload_bucket_enable_bucket_policy = false
upload_bucket_enable_public_access_block = false
upload_bucket_actions         = [ "s3:GetObject", "s3:ListBucket" ]
upload_bucket_principals      = ["*"]
upload_bucket_enable_cors = false
output_bucket_name            = "whizstream-output-videos"
output_bucket_enable_public_access_block = true
output_bucket_enable_bucket_policy = true
output_bucket_actions         = [ "s3:GetObject", "s3:ListBucket" ]
output_bucket_principals      = ["*"]
output_bucket_enable_cors = true


#SQS Queue
queue_name = "whizstream-upload-video-queue"
delay_seconds = 30
message_retention_seconds = 864000
receive_wait_time_seconds = 20

#security_groups
security_group_name = "security_group_sqs_polling"
description = "Security Group for SQS polling"
ingress_rules = [
  {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  },
  {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  },
  {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
]

#instance
ami_value = "ami-084568db4383264d4"
instance_type_value = "t2.micro"
key_value = "ATD"

#ecr
repository_names = [
  "sqs-processor",
  "video-transcoder",
]

#ecs
ecs_cluster_name = "video-transcoder-cluster"

#ecs_task_definition
task_family_name = "video-transcoder-family"
container_name = "video-transcoder-container"
image_uri = null