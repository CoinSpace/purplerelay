resource "google_compute_network" "vpc" {
  name                    = "${var.project}-vpc-${var.environment}"
  auto_create_subnetworks = false
  routing_mode            = "GLOBAL"
}

resource "google_compute_subnetwork" "public" {
  count         = length(var.subnet_public_cidrs)
  name          = "subnet-public-${count.index}-${var.environment}"
  region        = var.region
  network       = google_compute_network.vpc.id
  ip_cidr_range = var.subnet_public_cidrs[count.index]
}

resource "google_compute_subnetwork" "private" {
  count                    = length(var.subnet_private_cidrs)
  name                     = "subnet-private-${count.index}-${var.environment}"
  region                   = var.region
  network                  = google_compute_network.vpc.id
  ip_cidr_range            = var.subnet_private_cidrs[count.index]
  private_ip_google_access = true
}
/*
resource "google_compute_global_address" "sip" {
  provider = "google-beta"
  name     = "${var.project}-sip-${var.environment}"
}

# =================== Forwarding Rule ===================
resource "google_compute_global_forwarding_rule" "forwarding-rule" {
  name                  = "${var.project}-fr-${var.environment}"
  provider              = "google-beta"
  ip_protocol           = "TCP"
  load_balancing_scheme = "EXTERNAL"
  port_range            = "80"
  target                = google_compute_target_http_proxy.http-proxy.id
  ip_address            = google_compute_global_address.sip.id
}

# =================== Http Proxy ===================
resource "google_compute_target_http_proxy" "http-proxy" {
  name     = "${var.project}-http-proxy-${var.environment}"
  provider = "google-beta"
  url_map  = google_compute_url_map.url-map.id
}

# =================== Url Map ===================
resource "google_compute_url_map" "url-map" {
  name            = "l7-xlb-url-map"
  provider        = google-beta
  default_service = google_compute_backend_service.backend-service.id
}

# =================== Backend Service ===================
resource "google_compute_backend_service" "backend-service" {
  name                    = "${var.project}-backend-service-${var.environment}"
  provider                = "google-beta"
  protocol                = "HTTP"
  port_name               = "${var.project}-port-${var.environment}"
  load_balancing_scheme   = "EXTERNAL"
  timeout_sec             = 10
  enable_cdn              = true
  custom_request_headers  = ["X-Client-Geo-Location: {client_region_subdivision}, {client_city}"]
  custom_response_headers = ["X-Cache-Hit: {cdn_cache_status}"]
  health_checks           = [google_compute_health_check.default.id]
  backend {
    group           = google_compute_instance_group_manager.default.instance_group
    balancing_mode  = "UTILIZATION"
    capacity_scaler = 1.0
  }
}

resource "google_compute_router" "public" {
  name    = "${var.project}-gw-group-public-${var.environment}"
  network = google_compute_network.vpc.self_link
  region  = var.region
}

resource "google_compute_global_forwarding_rule" "default" {
  name                  = "l7-xlb-forwarding-rule"
  provider              = google-beta
  ip_protocol           = "TCP"
  load_balancing_scheme = "EXTERNAL"
  port_range            = "80"
  target                = google_compute_target_http_proxy.default.id
  ip_address            = google_compute_global_address.default.id
}

resource "google_compute_router" "private" {
  name    = "${var.project}-gw-group-private-${var.environment}"
  network = google_compute_network.vpc.self_link
  region  = var.region
}

module "cloud-nat-group-public" {
  source     = "terraform-google-modules/cloud-nat/google"
  version    = "~> 2.2"
  router     = google_compute_router.public.name
  project_id = var.project
  region     = var.region
  name       = "${var.project}-nat-public-${var.environment}"
}

module "cloud-nat-group-private" {
  source     = "terraform-google-modules/cloud-nat/google"
  version    = "~> 2.2"
  router     = google_compute_router.private.name
  project_id = var.project
  region     = var.region
  name       = "${var.project}-nat-private-${var.environment}"
}
*/
resource "google_compute_firewall" "security_group" {
  name    = "${var.project}-sg-${var.environment}"
  network = google_compute_network.vpc.id
  depends_on = [
    google_compute_network.vpc
  ]

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["22", "80", "443"]
  }
  source_ranges = ["0.0.0.0/0"]
}

resource "google_vpc_access_connector" "connector" {
  name          = "${var.project}-vpc-cn-${var.environment}"
  ip_cidr_range = "10.8.0.0/28"
  network       = google_compute_network.vpc.id
}
/*
resource "google_compute_firewall" "firewall" {
  name          = "${var.project}-fw-${var.environment}"
  provider      = "google-beta"
  direction     = "INGRESS"
  network       = google_compute_network.default.id
  source_ranges = ["130.211.0.0/22", "35.191.0.0/16"]
  allow {
    protocol = "tcp"
  }
  target_tags = ["allow-health-check"]
}*/