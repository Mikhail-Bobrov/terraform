terraform {
  backend "gcs" {
    credentials = "irex-cloud-test-2.json"
    bucket      = "my-test-bucket-terraform-state"
    prefix      = "terraform-test"
  }
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "4.74.0"
    }
  }
}

provider "google" {
  credentials = file("irex-cloud-test-2.json")
  project = var.project
  region  = var.region
}
