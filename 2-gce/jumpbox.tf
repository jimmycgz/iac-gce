module "hub_firewall_rules" {
  source       = "terraform-google-modules/network/google//modules/firewall-rules"
  version      = "5.2.0"
  project_id   = local.project_id
  network_name = local.vpc_network_name

  rules = local.hub_firewall_rules
}

module "cloud_nat_hub_vm" {
  source        = "terraform-google-modules/cloud-nat/google"
  version       = "2.1.0"
  project_id    = local.project_id
  region        = local.region
  create_router = true
  router        = format("%s-%s-%s", local.resource_prefix, "hub", "rtr")
  network       = local.vpc_network_name_selflink
  name          = format("%s-%s-%s", local.resource_prefix, "hub", "nat")
}

module "gce_vm_linux" {
  source        = "./modules/gce"
  image_family  = "ubuntu-2004-lts" # latest "ubuntu-2004-bionic-v2023xxxx"
  image_project = "ubuntu-os-cloud"
  # machine_type  = "n2-standard-4"
  machine_type           = "c3-highcpu-8"
  boot_disk_size         = 20
  instance_name          = local.jump_name_linux
  create_service_account = false
  project                = local.project_id
  subnetwork             = local.vpc_subnetwork_name
  region                 = local.region
  instance_zone          = "${local.region}-a"
  assign_pub_ip          = false
  # pub_ip                 = local.pub_ip_name_jump_linux == null ? "" : "${google_compute_address.pub_ip_jump_linux[0].address}"
  instance_sa_scope = local.instance_sa_scope
  instance_tags     = ["jumpbox-ssh"]
  labels            = local.common_labels
  # metadata_startup_script = local.metadata_startup_script
}

output "vm_ssh_command_linux" {
  value = module.gce_vm_linux.vm_ssh_command["linux"]
}

/*
module "gce_vm_win" {
  source                 = "../modules/gce"
  image_family           = "windows-2019" # latest "windows-server-2019-dc-v20230111"
  image_project          = "windows-cloud"
  machine_type           = "e2-medium"
  boot_disk_size         = 50
  instance_name          = local.jump_name_win
  create_service_account = false
  project                = local.project_id
  subnetwork             = local.subnetwork_link_jump
  region                 = var.region
  instance_zone          = "${var.region}-a"
  instance_sa_scope      = local.instance_sa_scope
  assign_pub_ip          = true
  pub_ip                 = local.pub_ip_name_jump_win == null ? "" : "${google_compute_address.pub_ip_jump_win[0].address}"
  instance_tags          = ["jumpbox-rdp"]
  labels                 = local.common_labels
  # metadata_startup_script = local.metadata_startup_script 
}

output "vm_ssh_command_win" {
  value = module.gce_vm_linux.vm_ssh_command["windows"]
}
output "pub_ip_jump_win" {
  value = google_compute_address.pub_ip_jump_win[0].address
}
*/