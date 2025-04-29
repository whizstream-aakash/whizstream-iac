#main/variables.tf

variable "aws_region" {
  description = "This is aws region"
}


//s3
variable "upload_bucket_name" {
  description = "Name of the upload S3 bucket"
}

variable "output_bucket_name" {
  description = "Name of the output S3 bucket"
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
variable "name" {}
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

