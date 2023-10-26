module "cloud_storage" {
  source = "../cloud_storage"
  region = var.region

  project = var.project
  environment = var.environment
}

module "cloud_run" {
  source = "../cloud_run"
  depends_on = [ module.cloud_storage ]
  region = var.region

  project = var.project
  environment = var.environment
  registry_id = var.registry_id
  app_name = var.app_name
  bucket = module.cloud_storage.bucket_name
}

module "load_balancer" {
  source = "../load_balancer"
  project = var.project
  environment = var.environment
  region = var.region
  cloud_run_name = "${var.project}-${var.region}-app-${var.environment}"
  domain_url = "${var.region}.${var.domain_url}"
  private_key = var.private_key
  certificate = var.certificate
}