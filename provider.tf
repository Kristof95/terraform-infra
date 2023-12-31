provider "aws" {
    region = var.AWS_REGION
}

terraform {
  backend "s3" {
     bucket = "practice-kr-state-bucket"
     key = "terraform.tfstate"
     region = "eu-central-1"
  }
}