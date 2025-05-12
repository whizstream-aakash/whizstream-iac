#main/modules/aws_s3_bucket/variables.tf

variable "aws_region" {
  description = "This is aws region"
}

variable "bucket_name" {
  description = "This is upload videos bucket name"
}

variable "enable_public_access_block" {
  description = "Whether to disable S3 Block Public Access restrictions"
  type        = bool
  default     = false
}

variable "enable_bucket_policy" {
  description = "Whether to create the S3 bucket policy"
  type        = bool
  default     = false
}

variable "actions" {
  description = "List of allowed actions in the bucket policy"
  type        = list(string)
}

variable "principals" {
  description = "List of AWS principals allowed access"
  type        = list(string)
  default     = []
}