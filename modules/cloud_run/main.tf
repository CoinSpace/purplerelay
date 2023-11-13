resource "google_cloud_run_service" "cloud_run" {
  name     = "${var.project}-${var.region}-app-${var.environment}"
  location = var.region

  template {
    metadata {
      annotations = {
        "run.googleapis.com/execution-environment" = "gen2",
        "run.googleapis.com/client-name" = "gcloud",
        "run.googleapis.com/client-version" = "452.0.0",
        "run.googleapis.com/cpu-throttling" = "false",
        "run.googleapis.com/startup-cpu-boost" = "true",
        "autoscaling.knative.dev/minScale" = "1",
        "autoscaling.knative.dev/maxScale" = "100",
      }
    }
    spec {
      #service_account_name = "fs-identity"
      #service_account_name="purplerelay-github"
      containers {
        image = "us-east1-docker.pkg.dev/${var.project}/${var.registry_id}/${var.app_name}:latest"
        env {
          name = "BUCKET"
          value = var.bucket
        }
        ports {
          container_port = 80
        }
        resources {
          limits = {
            cpu = "2.0"
            memory = "4Gi"
          }
        }
      }
    }
  }
  autogenerate_revision_name = true
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