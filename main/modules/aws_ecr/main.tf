resource "aws_ecr_repository" "sqs_processor_repo" {
  name = var.name

  image_scanning_configuration {
    scan_on_push = true
  }

  image_tag_mutability = "MUTABLE"

  tags = {
    Environment = terraform.workspace
    Project     = "whizstream"
  }
}