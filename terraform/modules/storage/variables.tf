variable "project_id" { type = string }
variable "region"     { type = string }

variable "environment" {
  description = "Environment name, appended to every bucket name"
  type        = string
}
