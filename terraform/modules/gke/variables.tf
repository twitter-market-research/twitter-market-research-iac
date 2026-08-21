variable "project_id" {
  description = "GCP project hosting the cluster"
  type        = string
}

variable "region" {
  description = "Region of the regional cluster"
  type        = string
}

variable "name_prefix" {
  description = "Prefix applied to cluster and node pool names"
  type        = string
  default     = "twitter-mr"
}

variable "network_id" {
  description = "Self link of the VPC hosting the cluster"
  type        = string
}

variable "subnet_id" {
  description = "Self link of the subnet hosting the nodes"
  type        = string
}

variable "pods_range_name" {
  description = "Name of the secondary range used for pods"
  type        = string
}

variable "services_range_name" {
  description = "Name of the secondary range used for services"
  type        = string
}

variable "master_ipv4_cidr_block" {
  description = "/28 reserved for the control plane, must not overlap the VPC"
  type        = string
  default     = "172.16.0.0/28"
}

variable "authorized_networks" {
  description = "CIDRs allowed to reach the control plane: display name => CIDR"
  type        = map(string)
}

variable "node_machine_type" {
  description = "Machine type of the cluster nodes"
  type        = string
  default     = "e2-standard-2"
}

variable "node_service_account" {
  description = "Email of the node service account, holding minimal privileges"
  type        = string
}
