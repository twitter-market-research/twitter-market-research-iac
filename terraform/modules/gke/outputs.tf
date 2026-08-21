output "cluster_name" {
  description = "Name of the GKE cluster"
  value       = google_container_cluster.main.name
}

output "cluster_endpoint" {
  description = "Private endpoint of the control plane"
  value       = google_container_cluster.main.endpoint
  sensitive   = true
}

output "cluster_location" {
  description = "Region of the regional cluster"
  value       = google_container_cluster.main.location
}
