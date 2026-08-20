# ---------- Raw data layer ----------
resource "google_storage_bucket" "tweets_raw" {
  name     = "${var.project_id}-tweets_raw"
  location = var.region

  storage_class               = "STANDARD"
  uniform_bucket_level_access = true
  public_access_prevention    = "enforced"

  # Make sure each data collected is versioned 
  versioning {
    enabled = true
  }

  labels = {
    project = "twitter-market-research"
    layer   = "raw"
  }
}

# -------------- Enriched data --------------
resource "google_storage_bucket" "tweets_enriched" {
  name     = "${var.project_id}-tweets-enriched"
  location = var.region

  storage_class               = "STANDARD"
  uniform_bucket_level_access = true
  public_access_prevention    = "enforced"

  versioning {
    enabled = true
  }

  labels = {
    project = "twitter-market-research"
    layer   = "enriched"
  }
}

# ---------- Entrepôt ----------
resource "google_bigquery_dataset" "tweets" {
  dataset_id  = "tweets"
  location    = var.region
  description = "Tweets Ligue 1 collectés via l'API X"

  labels = {
    project = "twitter-market-research"
  }
}