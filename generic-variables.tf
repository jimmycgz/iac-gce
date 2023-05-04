variable "google_project_id" {
  description = "The ID of the project where this VPC will be created"
}

variable "vpc_network_name" {
  description = "The name of the vpc network"
}

variable "labels" {
  type = map(any)
  default = {
    "Creator" = "terraform"
  }
}