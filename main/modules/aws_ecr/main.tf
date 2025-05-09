resource "aws_ecr_repository" "whizstream_processor_repository" {
  name = var.name

  image_scanning_configuration {
    scan_on_push = true
  }

  force_delete = true

  image_tag_mutability = "MUTABLE"

  tags = {
    Environment = terraform.workspace
    Project     = "whizstream"
  }
}