#main/modules/aws_s3_bucket/main.tf

provider "aws" {
  region = var.aws_region
}

resource "aws_s3_bucket" "example" {
  bucket = var.bucket_name
  force_destroy = true
}

 resource "aws_s3_bucket_policy" "example_policy"  {
    count  = var.enable_bucket_policy ? 1 : 0
    bucket = aws_s3_bucket.example.id
    policy = data.aws_iam_policy_document.s3_policy.json
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


