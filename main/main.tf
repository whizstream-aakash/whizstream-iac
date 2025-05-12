#main/main.tf

locals {
  environment         = terraform.workspace
  upload_bucket_name  = "${var.upload_bucket_name}-${local.environment}"
  output_bucket_name  = "${var.output_bucket_name}-${local.environment}"
  queue_name          = "${var.queue_name}-${local.environment}"
  security_group_name = "${var.security_group_name}-${local.environment}"
  ecs_cluster_name = "${var.ecs_cluster_name}-${local.environment}"
  task_family_name = "${var.task_family_name}-${local.environment}"
  container_name = "${var.container_name}-${local.environment}"
  video_transcoder_repo_url = module.aws_ecr_repository["video-transcoder"].repository_url
}

module "aws_s3_bucket_upload_videos" {
  source = "./modules/aws_s3_bucket"
  bucket_name = local.upload_bucket_name
  aws_region = var.aws_region
  enable_bucket_policy = var.upload_bucket_enable_bucket_policy
  principals = var.upload_bucket_principals
  actions = var.upload_bucket_actions
}

module "aws_s3_bucket_output_videos" {
  source = "./modules/aws_s3_bucket"
  bucket_name = local.output_bucket_name
  aws_region = var.aws_region
  enable_bucket_policy = var.output_bucket_enable_bucket_policy
  principals = var.output_bucket_principals
  actions = var.output_bucket_actions
}

module "aws_sqs_queue_module" {
  source = "./modules/sqs_queue"
  aws_region = var.aws_region 
  queue_name = local.queue_name
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

module "aws_ecr_repository" {
  source = "./modules/aws_ecr"
  for_each = toset(var.repository_names)
  name = "${each.value}-${local.environment}"
}

# module "aws_ecs_cluster"{
#   source = "./modules/aws_ecs"
#   ecs_cluster_name = local.ecs_cluster_name
# }

# module "aws_ecs_task_definition"{
#   source = "./modules/aws_ecs_task_definition"
#   task_family_name = local.task_family_name
#   container_name = local.container_name
#   image_uri = "video-transcoder-${local.environment}"
#   depends_on = [
#     module.aws_ecr_repository
#   ]
# }

# module "security_group_sqs_polling" {
#   source = "./modules/aws_security_groups"
#   security_group_name=local.security_group_name
#   description=var.description
#   ingress_rules = var.ingress_rules
# }

# module "ec2_instance" {
#   source = "./modules/aws_ec2"
#   ami_value = var.ami_value
#   instance_type_value = var.instance_type_value
#   key_value = var.key_value
#   # security_group_id = module.security_group_sqs_polling.security_group_id
# }

