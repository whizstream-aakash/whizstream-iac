#main/modules/aws_s3_bucket/main.tf

provider "aws" {
  region = var.aws_region
}

resource "aws_s3_bucket" "example" {
  bucket = var.bucket_name
  force_destroy = true
}

resource "aws_s3_bucket_public_access_block" "example" {
  count = var.enable_public_access_block ? 1 : 0

  bucket = aws_s3_bucket.example.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

 resource "aws_s3_bucket_policy" "example_policy"  {
    count  = var.enable_bucket_policy ? 1 : 0
    bucket = aws_s3_bucket.example.id
    policy = data.aws_iam_policy_document.s3_policy[0].json

    depends_on = [aws_s3_bucket_public_access_block.example]
 }

 data "aws_iam_policy_document" "s3_policy" {
  count = var.enable_bucket_policy ? 1 : 0
  statement {
    principals {
      type        = "AWS"
      identifiers = var.principals
    }
    actions = var.actions
    resources = [
      aws_s3_bucket.example.arn,
      "${aws_s3_bucket.example.arn}/*",
    ]
  } 
}

resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.example.id
  versioning_configuration {
    status = "Enabled"
  }
}


resource "aws_s3_bucket_cors_configuration" "example_cors" {
  count  = var.enable_cors ? 1 : 0
  bucket = aws_s3_bucket.example.id

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET", "HEAD"]
    allowed_origins = ["*"]
    expose_headers  = ["ETag"]
    max_age_seconds = 3000
  }

    depends_on = [aws_s3_bucket_public_access_block.example]
}

