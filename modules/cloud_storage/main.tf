resource "google_storage_bucket" "auto-expire" {
  name          = "${var.project}-${var.region}-bucket-${var.environment}"
  location      = var.region
  #force_destroy = true
}