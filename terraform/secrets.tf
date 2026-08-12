
resource "google_secret_manager_secret" "x_bearer_token" {
    secret_id = "x-api-bearer-token"
    replication {
        user_managed {
            replicas {
                locations = var.region
            }
        }
    }

    labels = {
        project = "twitter-market-research"
    }
}