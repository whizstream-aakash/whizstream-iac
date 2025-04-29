# modules/sqs_queue/outputs.tf
output "queue_arn" {
  value = aws_sqs_queue.terraform_queue.arn
}

output "queue_url" {
  value = aws_sqs_queue.terraform_queue.url
}   