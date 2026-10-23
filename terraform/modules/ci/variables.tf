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
