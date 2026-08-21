variable "project_id" {
  description = "GCP project hosting the platform"
  type        = string
}

variable "region" {
  description = "Location of the buckets"
  type        = string
}

variable "environment" {
  description = "Environment name, appended to every bucket name"
  type        = string
}
