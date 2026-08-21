variable "project_id" {
  description = "GCP project hosting the platform"
  type        = string
}

variable "region" {
  description = "Location of the BigQuery dataset"
  type        = string
}

variable "environment" {
  description = "Environment name, appended to the dataset id"
  type        = string
}
