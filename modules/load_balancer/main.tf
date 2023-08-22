resource "google_compute_region_network_endpoint_group" "cloudrun_neg" {
  provider              = google-beta
  name                  = "${var.project}-neg-${var.environment}"
  network_endpoint_type = "SERVERLESS"
  region                = var.region
  project = var.project
  cloud_run {
    service = var.cloud_run_name
  }
}

module "lb-http" {
  source            = "GoogleCloudPlatform/lb-http/google//modules/serverless_negs"
  version           = "9.1.0"

  project           = var.project
  name              = "${var.project}-lb-${var.environment}"

  managed_ssl_certificate_domains = ["YOUR_DOMAIN.COM"]
  ssl                             = false
  https_redirect                  = false

  backends = {
    default = {
      # List your serverless NEGs, VMs, or buckets as backends
      groups = [
        {
          group = google_compute_region_network_endpoint_group.cloudrun_neg.id
        }
      ]

      enable_cdn = false

      log_config = {
        enable      = true
        sample_rate = 1.0
      }

      iap_config = {
        enable               = false
        oauth2_client_id     = null
        oauth2_client_secret = null
      }

      description             = null
      custom_request_headers  = null
      security_policy         = null
    }
  }
}