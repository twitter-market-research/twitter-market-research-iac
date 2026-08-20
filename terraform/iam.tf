# ------- VM's Identity -------

resource "google_service_account" "dwh" {
  account_id   = "dwh-vm"
  display_name = "Service account of the DWH VM"
  description  = "Identity of the tweets ingestor and the docker stack"
}

# ------- Access -------

# Read the X token, on THIS secret only.
resource "google_secret_manager_secret_iam_member" "dwh_reads_token" {
  secret_id = google_secret_manager_secret.x_bearer_token.id
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${google_service_account.dwh.email}"
}

# Write data, on THESE buckets only.
resource "google_storage_bucket_iam_member" "dwh_writes_raw" {
  bucket = google_storage_bucket.tweets_raw.name
  role   = "roles/storage.objectAdmin"
  member = "serviceAccount:${google_service_account.dwh.email}"
}

resource "google_storage_bucket_iam_member" "dwh_writes_enriched" {
  bucket = google_storage_bucket.tweets_enriched.name
  role   = "roles/storage.objectAdmin"
  member = "serviceAccount:${google_service_account.dwh.email}"
}

# BigQuery: write into the dataset, and run query jobs.
resource "google_bigquery_dataset_iam_member" "dwh_writes_dataset" {
  dataset_id = google_bigquery_dataset.tweets.dataset_id
  role       = "roles/bigquery.dataEditor"
  member     = "serviceAccount:${google_service_account.dwh.email}"
}

resource "google_project_iam_member" "dwh_bq_jobs" {
  project = var.project_id
  role    = "roles/bigquery.jobUser"
  member  = "serviceAccount:${google_service_account.dwh.email}"
}

# Logs and metrics (required by the Ops Agent).
resource "google_project_iam_member" "dwh_observability" {
  for_each = toset([
    "roles/logging.logWriter",
    "roles/monitoring.metricWriter",
  ])

  project = var.project_id
  role    = each.value
  member  = "serviceAccount:${google_service_account.dwh.email}"
}
