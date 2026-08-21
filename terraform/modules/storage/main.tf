locals {
  layers = {
    raw      = "Raw X API payloads, immutable"
    enriched = "Enriched tweets, ready for the warehouse"
  }
}

resource "google_storage_bucket" "layer" {
  for_each = local.layers

  name     = "${var.project_id}-tweets-${each.key}-${var.environment}"
  project  = var.project_id
  location = var.region

  storage_class               = "STANDARD"
  uniform_bucket_level_access = true
  public_access_prevention    = "enforced"

  versioning {
    enabled = true
  }

  labels = {
    project     = "twitter-market-research"
    layer       = each.key
    environment = var.environment
  }
}
