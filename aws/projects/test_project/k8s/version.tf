provider "aws" {
  region  = "eu-west-2"

}
provider "kubernetes" {
  config_path = "~/.kube/config"
}
terraform {
  backend "s3" {
    bucket = "terraform-state-bucket-testaza"
    key    = "state-stage1/terraform-state-k8s.tf"
    region = "eu-west-2"
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.6"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0.0"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "1.14.0"
    }
  }
}