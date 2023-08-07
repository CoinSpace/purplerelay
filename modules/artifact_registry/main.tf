resource "google_artifact_registry_repository" "registry" {
  location      = var.region
  repository_id = "${var.project}-registry-${var.environment}"
  description   = "${var.project} image builded from github"
  format        = "DOCKER"
}