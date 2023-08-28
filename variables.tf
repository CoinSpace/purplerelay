//_______________PROJECT_______________//
variable "project" {
  default = "purplerelay"
}
variable "region" {
  default = "us-east1"
}
variable "environment" {
  default = "dev"
}

//_______________VPC_______________//
variable "subnet_public_cidrs" {
  type = list(string)
  default = ["10.46.0.0/16", "10.47.0.0/16", "10.48.0.0/16"]
}
variable "subnet_private_cidrs" {
  default = ["10.49.0.0/16", "10.50.0.0/16", "10.51.0.0/16"]
}

//_______________APP_______________//
variable "remote_uri" {
  type = string
  default = "https://github.com/purplerelay/relay"
}
variable "app_name" {
  type = string
  default = "strfry"
}

variable "regions" {
  type = list(string)
  default = ["us-east1", "us-west1", "us-central1", "southamerica-east1"]
}

variable "domain_url" {
  type = string
  default = "purplerelay.com"
}