
# ------- VM's Identity -------

resource "google_service_account" "dwh" {
    account_id = "dwh-vm"
    display_name = "Account service of DWH VM"
    description = "Identity of the tweets ingestor and the docker stack"
}


# ------ Defining Access ------

# access for reading the X token , only on CE secret
resource "google_secret_manager_secret_iam_member" "dwh_reads_token"'{
    secret_id = google_secret_manager_secret.bearer_token.id
    role      = "roles/secretmanager.secretAccessor"
    member    = "serviceAccount:${google_service_account.dwh.email}"
}

# Access for writing data in buckets : only on CES buckets
resource "google_storage_bucket_iam_number" "dwh_writes_enriched" {
    bucket = google_storage_bucket.tweets_raw.name
    role   = "roles/storage.objectAdmin"
    member = "serviceAccount:${google_service_account.dwh.email}"
}

resource "google_storage_bucket_iam_member" "dwh_writes_enriched" {
    bucket = google_storage_bucket.tweets_enriched.name
    role   = "roles/storage.objectAdmin"
    member = 
}

# Access for logs and metrics (prometheus , grafana , etc..)
resource "google_project_iam_meber" "dwh_observability" {
    for_each = toset([
        "roles/logging.logwriter",
        "roles/monitoring.metricWriter",
    ])

    project = var.project_id
    role    = each.value
    member  = "serviceAccount:${google_service_account.dwh.email}"
}