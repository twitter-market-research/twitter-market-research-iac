resource "google_secret_manager_secret" "x_bearer_token" {
  secret_id = "x-api-bearer-token-${var.environment}"
  project   = var.project_id

  replication {
    user_managed {
      replicas {
        location = var.region
      }
    }
  }

  labels = {
    project     = "twitter-market-research"
    environment = var.environment
  }
}