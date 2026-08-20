

output "vm_name" {
  description = "Twitter market research project's VM"
  value       = google_compute_instance.dwh.name
}

output "vm_internal_ip" {
  description = "Private IP of VM's instance"
  value       = google_compute_instance.dwh.network_interface[0].network_ip
}

output "dwh_service_account" {
  description = "Acount service of the VM instance"
  value       = google_service_account.dwh.email
}

output "bucket_tweets_raw" {
  value = google_storage_bucket.tweets_raw.name
}

output "bucket_tweets_enriched" {
  value = google_storage_bucket.tweets_enriched.name
}

output "bigquery_dataset" {
  value = google_bigquery_dataset.tweets.dataset_id
}
