variable "project_id" {
  description = "GCP project hosting the platform"
  type        = string
}

variable "region" {
  description = "Location of the registries, colocated withe the cluster"
  type        = string
}

variable "writers" {
  description = "Registry name => email of the service account allowed to push to it"
  type        = map(string)
}