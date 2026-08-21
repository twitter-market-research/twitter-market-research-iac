output "secret_id" {
  description = "Full resource id, used for IAM bindings"
  value       = google_secret_manager_secret.x_bearer_token.id
}