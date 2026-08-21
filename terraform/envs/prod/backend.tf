
terraform {
  backend "gcs" {
    bucket = "twitter-market-research-iac"
    prefix = "prod"
  }
}