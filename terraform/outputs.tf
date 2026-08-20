

output "dwh_node_ips" {
  description = "DWH cluster nodes: name => internal IP"
  value = {
    for k, vm in google_compute_instance.dwh : vm.name => vm.network_interface[0].network_ip
  }
}

output "dwh_node_fqdns" {
  description = "Internal DNS names, used for Kafka advertised.listeners and the ZooKeeper quorum"
  value = {
    for k, vm in google_compute_instance.dwh :
    vm.name => "${vm.name}.${vm.zone}.c.${var.project_id}.internal"
  }
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
