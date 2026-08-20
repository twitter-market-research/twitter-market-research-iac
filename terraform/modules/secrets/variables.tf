variable "project_id" {
  description = "GCP project hosting the platform"
  type        = string
}

variable "region" {
  description = "Location of the secret replica"
  type        = string
}

variable "environment" {
  description = "Environment name, appended to the secret id"
  type        = string
}
