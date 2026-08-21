data "terraform_remote_state" "platform" {
  backend = "gcs"

  config = {
    bucket = "twitter-market-research-iac"
    prefix = "platform"
  }
}

module "storage" {
  source = "../../modules/storage"

  project_id  = var.project_id
  region      = var.region
  environment = "prod"
}

module "warehouse" {
  source = "../../modules/warehouse"

  project_id  = var.project_id
  region      = var.region
  environment = "prod"
}

module "secrets" {
  source = "../../modules/secrets"

  project_id  = var.project_id
  region      = var.region
  environment = "prod"
}
