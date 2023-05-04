# Module to Create GCE VM

## Feature List
* Auto find the latest image from the image family
* If needed, add start up script to bootstrap the VM
* Auto generate the ssh command as output

## Example Usage
```
module "gce_vm" {
  source                  = "../../../modules/gce"
  image_family            = "ubuntu-2004-lts" # latest "ubuntu-2004-focal-v20221018"
  image_project           = "ubuntu-os-cloud"
  machine_type            = "n2-standard-4"
  boot_disk_size          = 70
  instance_name           = local.instance_name
  create_service_account  = false
  project                 = local.project
  subnetwork              = local.subnetwork_link
  region                  = local.region
  instance_zone           = "${local.region}-a"
  instance_sa_scope       = var.instance_sa_scope
  labels                  = local.labels
  metadata_startup_script = local.metadata_startup_script 
}
```

## Tips
* Get the ssh command as output

Add below output in your code, it'll generate the ssh command for you like the example:

```
# Example: gcloud compute ssh --project=corp-dev-111 --zone=europe-west2-a corp-dev-test-vm

output "vm_ssh_command" {
  value = module.gce_vm.vm_ssh_command
}
```
gcloud compute start-iap-tunnel platform-hub-jump-win-01 3389 \
    --local-host-port=localhost:3389 \
    --project=platform-hub-2 \
    --zone=europe-west2-a


* Define the bootstrap script like below
```
# In locals.tf
  metadata_startup_script = <<SCRIPT
    sudo apt update
    sudo apt install dnsutils -y
    sudo apt install -y telnet
    SCRIPT
```

* Finding GCE Images

Users can find the latest Ubuntu images on the GCE UI by selecting “Ubuntu” as the Operating System under the Boot Disk settings.

For a programmatic method, users can use the gcloud command to find the latest, release images:

gcloud compute images list --filter ubuntu-os-cloud
Daily, untested, images are found under the ubuntu-os-cloud-devel project:

gcloud compute images --project ubuntu-os-cloud list --filter ubuntu-2004-focal
gcloud compute images list --project windows-cloud --no-standard-images

Image Examples:
linux_image  = "https://console.cloud.google.com/compute/imagesDetail/projects/ubuntu-os-cloud/global/images/ubuntu-2004-focal-v20221018"
win_image    = "https://console.cloud.google.com/compute/imagesDetail/projects/windows-cloud/global/images/indows-server-2019-dc-v20230111"
