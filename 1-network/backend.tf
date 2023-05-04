terraform {
  backend "gcs" {
    bucket = "terraform-state-bt-demo-services-dev"
    prefix = "/network"
  }
}