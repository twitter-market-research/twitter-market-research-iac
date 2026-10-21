terraform {
  backend "gcs" {
    bucket = "twitter-market-research-iac"
    prefix = "ci"
  }
}