terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.82.2"
    }
  }
  backend "s3" {
    bucket = "client-info-state-4178564685849654"
    key = "terraform/state/terraform.tfstate"
    region = "us-east-1"
    encrypt = true
    dynamodb_table = "client-info-lock"
  }
}

provider "aws" {
  region = "us-east-1"
}