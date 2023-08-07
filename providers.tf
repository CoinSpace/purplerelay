terraform {
  backend "gcs" {
    bucket = "terraform-tfstate-skymedia"
    prefix = "purplerelay/terraform.tfstate"
  }
}

provider "google" {
  project = var.project
  region  = var.region
}