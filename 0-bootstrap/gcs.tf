resource "google_project_service" "storage_api" {
  project = var.google_project_id
  service = "storage-api.googleapis.com"

  disable_on_destroy = false
}

resource "google_storage_bucket" "gcs_bucket" {
  project                     = var.google_project_id
  name                        = var.bucket_name
  location                    = var.location
  uniform_bucket_level_access = var.uniform_access
  labels                      = var.labels
  force_destroy               = true
  versioning {
    enabled = var.enable_versioning
  }

  depends_on = [google_project_service.storage_api]
}