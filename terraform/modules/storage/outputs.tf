output "bucket_names" {
  description = "Layer name => bucket name"
  value       = { for k, b in google_storage_bucket.layer : k => b.name }
}
