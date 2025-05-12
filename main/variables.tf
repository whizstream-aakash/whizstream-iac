#main/variables.tf

variable "aws_region" {
  description = "This is aws region"
}


//s3
variable "upload_bucket_name" {
  description = "Name of the upload S3 bucket"
}

variable "upload_bucket_enable_public_access_block" {
  description = "Whether to disable S3 Block Public Access restrictions"
  type        = bool
  default     = false
}

variable "upload_bucket_enable_bucket_policy" {
  description = "Whether to create the S3 bucket policy"
  type        = bool
  default     = false
}

variable "upload_bucket_actions" {
  description = "List of allowed actions in the bucket policy"
  type        = list(string)
}

variable "upload_bucket_principals" {
  description = "List of AWS principals allowed access"
  type        = list(string)
  default     = []
}

variable "output_bucket_name" {
  description = "Name of the output S3 bucket"
}

variable "output_bucket_enable_bucket_policy" {
  description = "Whether to create the S3 bucket policy"
  type        = bool
  default     = false
}

variable "output_bucket_enable_public_access_block" {
  description = "Whether to disable S3 Block Public Access restrictions"
  type        = bool
  default     = false
}

variable "output_bucket_actions" {
  description = "List of allowed actions in the bucket policy"
  type        = list(string)
}

variable "output_bucket_principals" {
  description = "List of AWS principals allowed access"
  type        = list(string)
  default     = []
}

//queue
variable "queue_name" {
  description = "SQS queue name"
}

variable "tag" {
  description = "Mostly used for writing environment tag or categorize queue"
  default = "environment"
}

variable "delay_seconds"{
  description = "Set delay time for a message to appear in queue"
  type = number
}

variable "message_retention_seconds"{
    description = "Set how long the message can be stored in queue"
    type = number

}
variable "receive_wait_time_seconds"{
    description = "its long polling, which takes maximum of 20 seconds"
    type = number
}

//security_groups
variable "security_group_name" {}
variable "description" {}
variable "ingress_rules" {
  description = "List of ingress rules"
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
}

//ec2
variable "ami_value" {}
variable "instance_type_value" {}
variable "key_value"{}

//ecr
variable repository_names {}


//ecs
variable ecs_cluster_name{
    type = string
}

//ecs task definition
variable task_family_name {}
variable container_name {}
variable image_uri {}
