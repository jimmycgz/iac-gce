terraform {
  backend "gcs" {
    bucket = "terraform-state-bt-demo-services-dev"
    prefix = "2-gce"
  }
}