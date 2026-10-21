variable "project_id" {
    description = "ID of project GCP housing twitter-market-research"
    type        = string
}

variable "region" {
    description = "GCP default region for ressources"
    type        = string
    default     = "europe-west1"
}

variable "github-repository" {
    description = "Github repository allowed to authenticate, as owner/name"
    type        = string
    default     = "twitter-market-research/twitter-market-research-iac"
}

variable "state_bucket" {
    description = "Name of the bucket holding the Terraform states"
    type        = string
    default     = "twitter-market-research-iac"
}