resource "google_bigquery_dataset" "tweets" {
  dataset_id  = "tweets_${var.environment}"
  project     = var.project_id
  location    = var.region
  description = "Ligue 1 tweets collected from the X API"

  labels = {
    project     = "twitter-market-research"
    environment = var.environment
  }
}
