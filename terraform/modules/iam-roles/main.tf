resource "google_service_account" "gke_node" {
  account_id   = "gke-node"
  project      = var.project_id
  display_name = "GKE node service account"
  description  = "Identity of the GKE nodes, not of the workloads"
}

# define roles to set
resource "google_project_iam_member" "gke_node" {
  for_each = toset([
    "roles/logging.logWriter",
    "roles/monitoring.metricWriter",
    "roles/monitoring.viewer",
    "roles/stackdriver.resourceMetadata.writer",
    "roles/artifactregistry.reader",
  ])

  project = var.project_id
  role    = each.value
  member  = "serviceAccount:${google_service_account.gke_node.email}"
}