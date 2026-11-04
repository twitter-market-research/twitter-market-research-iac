output "workload_identity_provider" {
  description = "Full provider name, the workload_identity_provider input of google-github-actions/auth"
  value       = google_iam_workload_identity_pool_provider.github.name
}

output "plan_service_account" {
  description = "Email of the identity running terraform plan"
  value       = google_service_account.plan.email
}

output "apply_service_account" {
  description = "Email of the identity running terraform apply"
  value       = google_service_account.apply.email
}

output "image_pusher_service_accounts" {
  description = "Registry name => email of the identity allowed to push to it"
  value       = { for k, sa in google_service_account.image_pusher : k => sa.email }
}
