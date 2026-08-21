resource "google_project_service" "required" {
  for_each = toset([
    "compute.googleapis.com",
    "iap.googleapis.com",
    "container.googleapis.com",
    "secretmanager.googleapis.com",
    "storage.googleapis.com",
    "bigquery.googleapis.com",
  ])

  service            = each.value
  disable_on_destroy = false
}

module "network" {
  source = "../../modules/network"

  project_id = var.project_id
  region     = var.region

  depends_on = [google_project_service.required]
}

module "gke" {
  source = "../../modules/gke"

  project_id           = var.project_id
  region               = var.region
  network_id           = module.network.network_id
  subnet_id            = module.network.subnet_id
  pods_range_name      = module.network.pods_range_name
  services_range_name  = module.network.services_range_name
  node_service_account = module.iam_nodes.service_account_email

  authorized_networks = {
    "vpc-subnet" = "10.10.0.0/24" # le bastion vit dans ce sous-réseau
  }
}
