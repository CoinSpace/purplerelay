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

module "applications" {
  depends_on = [ module.artifact_registry, module.vpc ]
  source = "./modules/application"

  regions = var.regions
  project = var.project
  environment = var.environment
  registry_id = module.artifact_registry.registry_id
  app_name = var.app_name
}

module "load_balancer" {
  source = "./modules/load_balancer"
  project = var.project
  environment = var.environment
  region = var.region
  cloud_run_name = "${var.project}-${var.regions[0]}-app-${var.environment}"
}