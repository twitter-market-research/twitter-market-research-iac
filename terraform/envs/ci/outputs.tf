output "workload_identity_provider" {
  description = "Value for the workload_identity_provider input of google-github-actions/auth"
  value       = module.ci.workload_identity_provider
}

output "plan_service_account" {
  description = "Service account used by terraform plan jobs"
  value       = module.ci.plan_service_account
}

output "apply_service_account" {
  description = "Service account used by terraform apply jobs"
  value       = module.ci.apply_service_account
}