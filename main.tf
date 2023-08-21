module "vpc" {
  source           = "./modules/vpc"
  subnet_public_cidrs  = var.subnet_public_cidrs
  subnet_private_cidrs = var.subnet_private_cidrs
  region = var.region
  environment = var.environment
  project = var.project
}

resource "google_compute_router" "public" {
  name    = "${var.project}-gw-group-public-${var.environment}"
  network = module.vpc.self_link
  region  = var.region
}

resource "google_compute_router" "private" {
  name    = "${var.project}-gw-group-private-${var.environment}"
  network = module.vpc.self_link
  region  = var.region
}

module "cloud-nat-group-public" {
  source     = "terraform-google-modules/cloud-nat/google"
  version    = "~> 2.2"
  router     = google_compute_router.public.name
  project_id = var.project
  region     = var.region
  name       = "${var.network_prefix}-cloud-nat-group1"
}

module "cloud-nat-group-private" {
  source     = "terraform-google-modules/cloud-nat/google"
  version    = "~> 2.2"
  router     = google_compute_router.group2.name
  project_id = var.project
  region     = var.group2_region
  name       = "${var.network_prefix}-cloud-nat-group2"
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

module "gce-lb-http" {
  source            = "GoogleCloudPlatform/lb-http/google"
  version           = "~> 9.0"

  project           = var.project
  name              = "${var.project}-group-http-lb-${var.environment}"
  target_tags       = [
    "subnet-public-0-${var.environment}","",
    "subnet-private-0-${var.environment}",
  ]
  backends = {
    default = {
      description                     = null
      port                            = var.service_port
      protocol                        = "HTTP"
      port_name                       = var.service_port_name
      timeout_sec                     = 10
      enable_cdn                      = false
      custom_request_headers          = null
      custom_response_headers         = null
      security_policy                 = null
      compression_mode                = null

      connection_draining_timeout_sec = null
      session_affinity                = null
      affinity_cookie_ttl_sec         = null

      health_check = {
        check_interval_sec  = null
        timeout_sec         = null
        healthy_threshold   = null
        unhealthy_threshold = null
        request_path        = "/"
        port                = var.service_port
        host                = null
        logging             = null
      }

      log_config = {
        enable = true
        sample_rate = 1.0
      }

      groups = [
        {
          # Each node pool instance group should be added to the backend.
          group                        = var.backend
          balancing_mode               = null
          capacity_scaler              = null
          description                  = null
          max_connections              = null
          max_connections_per_instance = null
          max_connections_per_endpoint = null
          max_rate                     = null
          max_rate_per_instance        = null
          max_rate_per_endpoint        = null
          max_utilization              = null
        },
      ]

      iap_config = {
        enable               = false
        oauth2_client_id     = null
        oauth2_client_secret = null
      }
    }
  }
}