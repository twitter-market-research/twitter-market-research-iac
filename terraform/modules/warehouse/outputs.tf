output "dataset_id" {
  description = "Id of the BigQuery dataset"
  value       = google_bigquery_dataset.tweets.dataset_id
}
