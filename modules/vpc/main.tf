resource "google_compute_network" "vpc" {
  name                    = "${var.project}-vpc-${var.environment}"
  auto_create_subnetworks = false
  routing_mode            = "GLOBAL"
}

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

resource "google_vpc_access_connector" "connector" {
  name          = "${var.project}-vpc-cn-${var.environment}"
  ip_cidr_range = "10.8.0.0/28"
  network       = google_compute_network.vpc.id
}