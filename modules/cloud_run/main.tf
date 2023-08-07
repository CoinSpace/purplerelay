resource "google_cloud_run_service" "cloud_run" {
  name     = "${var.project}-app-${var.environment}"
  location = var.region

  template {
    spec {
      containers {
        image = "${var.region}-docker.pkg.dev/${var.project}/${var.registry_id}/${var.app_name}"
        ports {
          container_port = 80
        }
      }
    }
  }
  traffic {
    percent         = 100
    latest_revision = true
  }
}

resource "google_cloud_run_service_iam_policy" "noauth" {
  location    = google_cloud_run_service.cloud_run.location
  project     = google_cloud_run_service.cloud_run.project
  service     = google_cloud_run_service.cloud_run.name

  policy_data = data.google_iam_policy.noauth.policy_data
}

data "google_iam_policy" "noauth" {
  binding {
    role = "roles/run.invoker"
    members = [
      "allUsers",
    ]
  }
}