output "service_account_email" {
  description = "Email of the GKE node service account"
  value       = google_service_account.gke_node.email
}
