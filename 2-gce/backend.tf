terraform {
  backend "gcs" {
    bucket = "bkt-terraform-state-demo"
    prefix = "tf-state/iac-gce/2-gce"
  }
}