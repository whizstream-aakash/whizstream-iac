#main/main.tf

locals {
  environment         = terraform.workspace
  upload_bucket_name  = "${var.upload_bucket_name}-${local.environment}"
  output_bucket_name  = "${var.output_bucket_name}-${local.environment}"
  queue_name          = "${var.queue_name}-${local.environment}"
}

module "aws_s3_bucket_upload_videos" {
  source = "./modules/aws_s3_bucket"
  bucket_name = local.upload_bucket_name
  aws_region = var.aws_region
}

module "aws_s3_bucket_output_videos" {
  source = "./modules/aws_s3_bucket"
  bucket_name = local.output_bucket_name
  aws_region = var.aws_region
}

module "aws_sqs_queue_module" {
  source = "./modules/sqs_queue"
  aws_region = var.aws_region 
  queue_name = var.queue_name
  delay_seconds = var.delay_seconds
  message_retention_seconds = var.message_retention_seconds
  receive_wait_time_seconds = var.receive_wait_time_seconds
  tag = local.environment
}

resource "aws_sqs_queue_policy" "s3_sqs_policy" {
  queue_url = module.aws_sqs_queue_module.queue_url

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "s3.amazonaws.com"
        }
        Action = "SQS:SendMessage"
        Resource = module.aws_sqs_queue_module.queue_arn
        Condition = {
          ArnLike = {
            "aws:SourceArn" = module.aws_s3_bucket_upload_videos.bucket_arn
          }
        }
      }
    ]
  })
}

resource "aws_s3_bucket_notification" "s3_to_sqs_notification" {
  bucket = module.aws_s3_bucket_upload_videos.bucket_id

  queue {
    queue_arn     = module.aws_sqs_queue_module.queue_arn
    events        = ["s3:ObjectCreated:*"]
  }

  depends_on = [
    aws_sqs_queue_policy.s3_sqs_policy
  ]
}

module "security_group_sqs_polling" {
  source = "./modules/aws_security_groups"
  name=var.name
  description=var.description
  vpc_id=var.vpc_id

  ingress_rules = var.ingress_rules
}

module "ec2_instance" {
  source = "./modules/aws_ec2"
  ami_value = var.ami_value
  instance_type_value = var.instance_type_value
  key_value = var.key_value
  security_group_id = module.security_group_sqs_polling.security_group_id
}