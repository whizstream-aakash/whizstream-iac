#main/modules/terraform.tfvars

#S3 Bucket
aws_region="us-east-1"
upload_bucket_name = "whizstream-upload-videos"
output_bucket_name = "whizstream-output-videos"

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