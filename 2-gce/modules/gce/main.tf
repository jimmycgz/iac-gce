locals {
  dns_project = var.dns_project == "" ? var.project : var.dns_project
  labels      = merge(var.common_labels, var.labels)
}

data "google_compute_image" "image" {
  name    = var.image_name
  family  = var.image_family
  filter  = var.image_name == null ? var.filter : null
  project = var.image_project
}

data "google_compute_zones" "available" {
  count   = var.instance_zone == null ? 1 : 0
  project = var.project
  region  = var.region
}

resource "random_shuffle" "zone" {
  count        = var.instance_zone == null ? 1 : 0
  input        = data.google_compute_zones.available[0].names
  result_count = 1
}

resource "google_service_account" "instance_sa" {
  count        = var.sa_account_id != "" ? 1 : 0
  account_id   = var.sa_account_id
  display_name = "${var.instance_name} Service Account"
  project      = var.project
}


data "google_service_account" "existing_sa" {
  count      = var.existing_sa_account_id != "" ? 1 : 0
  account_id = var.existing_sa_account_id
  project    = var.project
}

resource "google_compute_instance" "instance" {
  name         = var.instance_name
  machine_type = var.machine_type
  zone         = var.instance_zone == null ? one(random_shuffle.zone[0].result) : var.instance_zone
  project      = var.project

  tags   = var.instance_tags
  labels = local.labels
  boot_disk {
    initialize_params {
      image = data.google_compute_image.image.self_link
      size  = var.boot_disk_size
      type  = var.boot_disk_type
    }
  }

  network_interface {
    network    = var.network != "" && var.subnetwork == "" ? var.network : ""
    subnetwork = var.subnetwork != "" && var.network == "" ? var.subnetwork : ""
    network_ip = var.network_ip
    dynamic "access_config" {
      for_each = var.assign_pub_ip ? [1] : []
      content {
        nat_ip       = var.pub_ip == "" ? "" : var.pub_ip
        network_tier = "PREMIUM"
      }
    }

  }

  allow_stopping_for_update = var.allow_stopping_for_update
  metadata_startup_script   = var.metadata_startup_script

  dynamic "service_account" {
    for_each = var.sa_account_id != "" ? [1] : (var.existing_sa_account_id != "" ? [1] : [])
    content {
      email  = try(google_service_account.instance_sa[0].email, data.google_service_account.existing_sa[0].email)
      scopes = var.instance_sa_scope
    }
  }

  dynamic "attached_disk" {
    for_each = var.additional_disk_suffix != "" ? [1] : (var.additional_disk_suffix != "" ? [1] : [])
    content {
      source      = google_compute_disk.additional_instance_disk[0].id
      device_name = "${var.instance_name}-${var.additional_disk_suffix}"
    }
  }

  lifecycle {
    ignore_changes = [metadata, boot_disk[0].initialize_params]
  }
}

resource "google_compute_disk" "additional_instance_disk" {
  count   = var.additional_disk_suffix != "" ? 1 : 0
  name    = "${var.instance_name}-${var.additional_disk_suffix}"
  type    = var.additional_disk_type
  project = var.project
  zone    = var.instance_zone == null ? one(random_shuffle.zone[0].result) : var.instance_zone
  size    = var.additional_disk_size
  labels  = local.labels
}

resource "google_project_iam_member" "project" {
  for_each = var.sa_account_id != "" ? toset(var.service_account_project_roles) : []
  project  = var.project
  role     = each.value
  member   = try("serviceAccount:${google_service_account.instance_sa[0].email}", "serviceAccount:${data.google_service_account.existing_sa[0].email}")
}