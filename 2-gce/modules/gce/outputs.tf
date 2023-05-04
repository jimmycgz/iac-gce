output "gce_image_self_link" {
  value = data.google_compute_image.image.self_link
}

output "name" {
  value = data.google_compute_image.image.name
}

output "id" {
  value = data.google_compute_image.image.id
}

output "vm_name" {
  value = google_compute_instance.instance.name
}

output "vm_project" {
  value = google_compute_instance.instance.project
}

output "vm_zone" {
  value = google_compute_instance.instance.zone
}

output "vm_ssh_command" {
  value = {
    "linux"   = "gcloud compute ssh --project=${google_compute_instance.instance.project} --zone=${google_compute_instance.instance.zone} ${google_compute_instance.instance.name}",
    "windows" = "gcloud compute start-iap-tunnel ${google_compute_instance.instance.name} --local-host-port=localhost:3389 ${google_compute_instance.instance.name}"
  }
} 