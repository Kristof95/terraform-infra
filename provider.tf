provider "aws" {
    region = var.AWS_REGION
}

terraform {
  backend "s3" {
    bucket = "practice-kr-state-bucket"
    key = "terraform.tfstate"
    workspace_key_prefix = "docker-demo-3"
    region = "eu-central-1"
  }
}