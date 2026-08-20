
variable "project_id" {
  description = "ID of project GCP housing twitter-market-research"
  type        = string
}

variable "region" {
  description = "GCP default region for ressources"
  type        = string
  default     = "europe-west1"
}

variable "zone" {
  description = "GCP default zone for ressources"
  type        = string
  default     = "europe-west1-b"
}

variable "machine_type" {
  description = "Type de machine de la VM DWH (stack Kafka 3 brokers + MinIO + monitoring)"
  type        = string
  default     = "e2-standard-2"
}
