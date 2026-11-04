variable "project_id" {
  description = "GCP project hosting the platform"
  type        = string
}

variable "github_repository" {
  description = "GitHub repository allowed to authenticate, as owner/name"
  type        = string
}

variable "state_bucket" {
  description = "Name of the bucket holding the Terraform states"
  type        = string
}

variable "apply_environment" {
  description = "GitHub environment whose jobs may impersonate the apply identity"
  type        = string
  default     = "production"
}

variable "image_repositories" {
  description = "Regidtry name => Github repository (owner/name) allowed to push to it from main"
  type        = map(string)
}
