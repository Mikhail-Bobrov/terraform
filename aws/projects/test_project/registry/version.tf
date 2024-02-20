terraform {
  backend "s3" {
    bucket = "terraform-state-bucket-testaza"
    key    = "state-stage1/terraform-state-registry.tf"
    region = "eu-west-2"
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}
provider "aws" {
  region  = var.region
}

