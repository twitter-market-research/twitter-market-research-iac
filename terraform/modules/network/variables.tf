variable "project_id" {
  description = "GCP project hosting the platform"
  type        = string
}

variable "region" {
  description = "Region for regional resources"
  type        = string
}

variable "name_prefix" {
  description = "Prefix applied to every resource name"
  type        = string
  default     = "twitter-mr"
}

variable "subnet_cidr" {
  description = "Primary range of the subnet (nodes and VMs)"
  type        = string
  default     = "10.10.0.0/24"
}

variable "pods_cidr" {
  description = "Secondary range for GKE pods"
  type        = string
  default     = "10.20.0.0/16"
}

variable "services_cidr" {
  description = "Secondary range for GKE services"
  type        = string
  default     = "10.21.0.0/20"
}
