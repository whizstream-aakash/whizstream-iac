#main/backend.tf

terraform {
  backend "s3" {
    bucket               = "my-terraform-remote-state-bucket-aakash0912"
    key                  = "terraform.tfstate"
    region               = "us-east-1"
    dynamodb_table       = "terraform-locks"
    encrypt              = true
    workspace_key_prefix = "envs"
  }
}