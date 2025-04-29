//modules/aws_ec2/main.tf

provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "ec2_instance" {
  ami                    = var.ami_value
  instance_type          = var.instance_type_value
  key_name               = var.key_value
  # vpc_security_group_ids = [var.security_group_id]
}