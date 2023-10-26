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

module "applications_us-east1" {
  depends_on = [ module.artifact_registry, module.vpc ]
  source = "./modules/application"

  region = "us-east1"
  project = var.project
  environment = var.environment
  registry_id = module.artifact_registry.registry_id
  app_name = var.app_name
  domain_url = var.domain_url
  private_key = var.private_key
  certificate = var.certificate
}

module "applications_us-west2" {
  depends_on = [ module.artifact_registry, module.vpc ]
  source = "./modules/application"

  region = "us-west2"
  project = var.project
  environment = var.environment
  registry_id = module.artifact_registry.registry_id
  app_name = var.app_name
  domain_url = var.domain_url
  private_key = var.private_key
  certificate = var.certificate
}

module "applications_southamerica-east1" {
  depends_on = [ module.artifact_registry, module.vpc ]
  source = "./modules/application"

  region = "southamerica-east1"
  project = var.project
  environment = var.environment
  registry_id = module.artifact_registry.registry_id
  app_name = var.app_name
  domain_url = var.domain_url
  private_key = var.private_key
  certificate = var.certificate
}

module "applications_southamerica-west1" {
  depends_on = [ module.artifact_registry, module.vpc ]
  source = "./modules/application"

  region = "southamerica-west1"
  project = var.project
  environment = var.environment
  registry_id = module.artifact_registry.registry_id
  app_name = var.app_name
  domain_url = var.domain_url
  private_key = var.private_key
  certificate = var.certificate
}

module "applications_northamerica-northeast1" {
  depends_on = [ module.artifact_registry, module.vpc ]
  source = "./modules/application"

  region = "northamerica-northeast1"
  project = var.project
  environment = var.environment
  registry_id = module.artifact_registry.registry_id
  app_name = var.app_name
  domain_url = var.domain_url
  private_key = var.private_key
  certificate = var.certificate
}

module "applications_asia-east1" {
  depends_on = [ module.artifact_registry, module.vpc ]
  source = "./modules/application"

  region = "asia-east1"
  project = var.project
  environment = var.environment
  registry_id = module.artifact_registry.registry_id
  app_name = var.app_name
  domain_url = var.domain_url
  private_key = var.private_key
  certificate = var.certificate
}

module "applications_asia-east2" {
  depends_on = [ module.artifact_registry, module.vpc ]
  source = "./modules/application"

  region = "asia-east2"
  project = var.project
  environment = var.environment
  registry_id = module.artifact_registry.registry_id
  app_name = var.app_name
  domain_url = var.domain_url
  private_key = var.private_key
  certificate = var.certificate
}

module "applications_asia-northeast1" {
  depends_on = [ module.artifact_registry, module.vpc ]
  source = "./modules/application"

  region = "asia-northeast1"
  project = var.project
  environment = var.environment
  registry_id = module.artifact_registry.registry_id
  app_name = var.app_name
  domain_url = var.domain_url
  private_key = var.private_key
  certificate = var.certificate
}

module "applications_asia-northeast3" {
  depends_on = [ module.artifact_registry, module.vpc ]
  source = "./modules/application"

  region = "asia-northeast3"
  project = var.project
  environment = var.environment
  registry_id = module.artifact_registry.registry_id
  app_name = var.app_name
  domain_url = var.domain_url
  private_key = var.private_key
  certificate = var.certificate
}

module "applications_asia-south1" {
  depends_on = [ module.artifact_registry, module.vpc ]
  source = "./modules/application"

  region = "asia-south1"
  project = var.project
  environment = var.environment
  registry_id = module.artifact_registry.registry_id
  app_name = var.app_name
  domain_url = var.domain_url
  private_key = var.private_key
  certificate = var.certificate
}

module "applications_australia-southeast1" {
  depends_on = [ module.artifact_registry, module.vpc ]
  source = "./modules/application"

  region = "australia-southeast1"
  project = var.project
  environment = var.environment
  registry_id = module.artifact_registry.registry_id
  app_name = var.app_name
  domain_url = var.domain_url
  private_key = var.private_key
  certificate = var.certificate
}

module "applications_me-central1" {
  depends_on = [ module.artifact_registry, module.vpc ]
  source = "./modules/application"

  region = "me-central1"
  project = var.project
  environment = var.environment
  registry_id = module.artifact_registry.registry_id
  app_name = var.app_name
  domain_url = var.domain_url
  private_key = var.private_key
  certificate = var.certificate
}

module "applications_me-west1" {
  depends_on = [ module.artifact_registry, module.vpc ]
  source = "./modules/application"

  region = "me-west1"
  project = var.project
  environment = var.environment
  registry_id = module.artifact_registry.registry_id
  app_name = var.app_name
  domain_url = var.domain_url
  private_key = var.private_key
  certificate = var.certificate
}

module "applications_europe-north1" {
  depends_on = [ module.artifact_registry, module.vpc ]
  source = "./modules/application"

  region = "europe-north1"
  project = var.project
  environment = var.environment
  registry_id = module.artifact_registry.registry_id
  app_name = var.app_name
  domain_url = var.domain_url
  private_key = var.private_key
  certificate = var.certificate
}

module "applications_europe-west2" {
  depends_on = [ module.artifact_registry, module.vpc ]
  source = "./modules/application"

  region = "europe-west2"
  project = var.project
  environment = var.environment
  registry_id = module.artifact_registry.registry_id
  app_name = var.app_name
  domain_url = var.domain_url
  private_key = var.private_key
  certificate = var.certificate
}

module "applications_europe-west6" {
  depends_on = [ module.artifact_registry, module.vpc ]
  source = "./modules/application"

  region = "europe-west6"
  project = var.project
  environment = var.environment
  registry_id = module.artifact_registry.registry_id
  app_name = var.app_name
  domain_url = var.domain_url
  private_key = var.private_key
  certificate = var.certificate
}

module "applications_europe-central2" {
  depends_on = [ module.artifact_registry, module.vpc ]
  source = "./modules/application"

  region = "europe-central2"
  project = var.project
  environment = var.environment
  registry_id = module.artifact_registry.registry_id
  app_name = var.app_name
  domain_url = var.domain_url
  private_key = var.private_key
  certificate = var.certificate
}
