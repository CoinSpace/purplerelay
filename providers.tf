terraform {
  backend "gcs" {
    bucket = "terraform-tfstate-skymedia"
    prefix = "purplerelay/terraform.tfstate"
  }

  required_providers {
    google = {
      source = "hashicorp/google"
      version = "4.79"
    }
  }
}

provider "google" {
  project = var.project
  region  = var.region
}
