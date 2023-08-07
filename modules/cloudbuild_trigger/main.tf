resource "google_cloudbuild_trigger" "repo-trigger" {
  location = "us-central1"

  trigger_template {
    branch_name = "main"
    repo_name   = "my-repo"
  }

  substitutions = {
    _FOO = "bar"
    _BAZ = "qux"
  }

  filename = "./../../utils/cloudbuild.yaml"
}

resource "google_cloudbuildv2_repository" "repository" {
  name = "${var.project}-repository"
  parent_connection = google_cloudbuildv2_connection.my-connection.id
  remote_uri = var.remote_uri
}

resource "google_cloudbuildv2_connection" "my-connection" {
  location = "us-central1"
  name = "my-connection"

  github_config {
    app_installation_id = 123123
    authorizer_credential {
      oauth_token_secret_version = "projects/my-project/secrets/github-pat-secret/versions/latest"
    }
  }
}