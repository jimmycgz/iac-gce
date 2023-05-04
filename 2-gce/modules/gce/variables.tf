

variable "assign_pub_ip" {
  default = false
  type    = bool
}

variable "pub_ip" {
  default = ""
  type    = string
}

variable "image_name" {
  default = null
  type    = string
}

variable "image_family" {
  default = null
  type    = string
}

variable "filter" {
  default = null
  type    = string
}

variable "image_project" {
  default = null
  type    = string
}

variable "create_service_account" {
  default = false
  type    = string
}

variable "instance_name" {
  default = "gce_instance"
  type    = string
}

variable "machine_type" {
  default = "e2-micro"
  type    = string
}

variable "boot_disk_size" {
  default = "10"
  type    = string
}

variable "boot_disk_type" {
  default = "pd-balanced"
  type    = string
}


variable "project" {
  default = null
  type    = string
}

variable "instance_tags" {
  default = []
  type    = list(any)
}

variable "allow_stopping_for_update" {
  default = true
  type    = string
}

variable "metadata_startup_script" {
  default = ""
  type    = string
}

variable "sa_account_id" {
  default = ""
  type    = string
}

variable "region" {
  default = "us-west1"
}

variable "instance_zone" {
  default = null
  type    = string
}

variable "service_account_project_roles" {
  default = [
    "roles/compute.admin",
    "roles/storage.admin",
  ]
  type = list(any)
}

variable "network" {
  default = ""
  type    = string
}

variable "subnetwork" {
  default = ""
  type    = string
}

variable "network_ip" {
  default = ""
  type    = string
}

variable "dns_ttl" {
  default = 300
  type    = number
}

variable "dns_record_name" {
  default = ""
  type    = string
}

variable "dns_managed_zone" {
  default = ""
  type    = string
}

variable "create_a_record" {
  default = false
  type    = string
}

variable "create_cname_record" {
  default = false
}

variable "cname_record_names" {
  default = []
  type    = list(any)
}

variable "dns_project" {
  default = ""
  type    = string
}


variable "instance_sa_scope" {
  default = ["cloud-platform"]
  type    = list(any)
}

variable "existing_sa_account_id" {
  default = ""
  type    = string
}


variable "labels" {
  description = "The list of labels (key/value pairs) to be applied to instances"
  default     = {}
}

variable "common_labels" {
  type = map(any)
  default = {
    "creator" = "terraform"
  }
}

variable "additional_disk_suffix" {
  type    = string
  default = ""
}

variable "additional_disk_type" {
  type    = string
  default = "pd-balanced"
}

variable "additional_disk_size" {
  type    = string
  default = "100"
}