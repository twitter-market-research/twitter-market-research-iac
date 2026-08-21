output "network_id" {
  description = "Self link of the VPC"
  value       = google_compute_network.main.id
}

output "network_name" {
  value = google_compute_network.main.name
}

output "subnet_id" {
  description = "Self link of the subnet, consumed by GKE"
  value       = google_compute_subnetwork.main.id
}

output "pods_range_name" {
  value = "gke-pods"
}

output "services_range_name" {
  value = "gke-services"
}
