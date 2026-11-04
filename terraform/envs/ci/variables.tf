variable "project_id" {
  description = "ID of project GCP housing twitter-market-research"
  type        = string
}

variable "region" {
  description = "GCP default region for ressources"
  type        = string
  default     = "europe-west1"
}

variable "github_repository" {
  description = "Github repository allowed to authenticate, as owner/name"
  type        = string
  default     = "twitter-market-research/twitter-market-research-iac"
}

variable "state_bucket" {
  description = "Name of the bucket holding the Terraform states"
  type        = string
  default     = "twitter-market-research-iac"
}

variable "image_repositories" {
  description = "Regidtry name => Github repository (owner/name) allowed to push to it from main"
  type        = map(string)
  default = {
    dwh        = "twitter-market-research/twitter-market-research-dwh"
    dashboards = "twitter-market-research/twitter-market-research-dashboards"
  }
}