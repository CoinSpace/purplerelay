module "cloud_storage" {
  source = "../cloud_storage"
  count = length(var.regions)
  region = var.regions[count.index]

  project = var.project
  environment = var.environment
}

module "cloud_run" {
  source = "../cloud_run"
  depends_on = [ module.cloud_storage ]
  count = length(var.regions)
  region = var.regions[count.index]

  project = var.project
  environment = var.environment
  registry_id = var.registry_id
  app_name = var.app_name
  bucket = module.cloud_storage[count.index].bucket_name
}