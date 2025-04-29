#main/modules/sqs_queue/variables.tf

variable "aws_region" {
  description = "This is aws region"
}

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
