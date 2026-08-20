resource "google_secret_manager_secret" "x_bearer_token" {
  secret_id = "x-api-bearer-token"

  # API enablement is not referenced anywhere, so Terraform cannot infer the
  # ordering on its own. Without this, both start in parallel and the secret
  # fails while the API is still activating.
  depends_on = [google_project_service.required]

  replication {
    user_managed {
      replicas {
        location = var.region
      }
    }
  }

  labels = {
    project = "twitter-market-research"
  }
}
