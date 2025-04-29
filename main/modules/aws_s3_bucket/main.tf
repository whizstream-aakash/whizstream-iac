#main/modules/main.tf

provider "aws" {
  region = var.aws_region
}

resource "aws_s3_bucket" "example" {
 bucket = var.bucket_name
}

resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.example.id

  versioning_configuration {
    status = "Enabled"
  }
}


