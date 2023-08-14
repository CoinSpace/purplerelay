module "cloud_storage" {
  source = "./modules/cloud_storage"
  region = var.region
  project = var.project
  environment = var.environment
}


module "vpc" {
  source           = "./modules/vpc"
  subnet_public_cidrs  = var.subnet_public_cidrs
  subnet_private_cidrs = var.subnet_private_cidrs
  region = var.region
  environment = var.environment
  project = var.project
}

module "artifact_registry" {
  source = "./modules/artifact_registry"

  region = var.region
  project = var.project
  environment = var.environment
}

module "cloud_run" {
  source = "./modules/cloud_run"
  region = var.region
  project = var.project
  environment = var.environment
  registry_id = module.artifact_registry.registry_id
  app_name = var.app_name
}
