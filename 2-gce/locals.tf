data "google_compute_subnetwork" "my-subnetwork" {
  name    = "${local.vpc_network_name}-subnet-01"
  region  = local.region
  project = local.project_id
}

locals {
  bu_name         = "hub"
  env             = "global"
  resource_prefix = "${local.bu_name}-${local.env}"

  region     = "us-central1"
  project_id = var.google_project_id

  jump_name_linux  = "${local.resource_prefix}-jump-linux-01"
  jump_image_linux = "projects/ubuntu-os-cloud/global/images/family/ubuntu-2004-lts"

  # subnetwork_link_jump   = one(flatten([for vpc in module.subnets : [for f in vpc.subnets : f.self_link if length(regexall(".*jump.*", f.self_link)) > 0]]))
  vpc_network_name          = var.vpc_network_name
  vpc_network_name_selflink = "https://www.googleapis.com/compute/v1/projects/${local.project_id}/global/networks/${local.vpc_network_name}"
  vpc_subnetwork_name       = "https://www.googleapis.com/compute/v1/projects/${local.project_id}/regions/us-central1/subnetworks/${local.vpc_network_name}-subnet-01"
  instance_sa_scope         = ["cloud-platform"]

  common_labels = merge(
    var.common_labels,
    {
      "env" = local.env
    }
  )

  hub_firewall_rules = [
    {
      allow = [{
        ports    = ["22", "5432", "5460"]
        protocol = "tcp"
        },
      ]
      deny                    = []
      description             = "Demo Allow egress to somewhere"
      direction               = "EGRESS"
      log_config              = null
      name                    = "test-fw-egress-allow-jump-host-db-rule-${local.vpc_network_name}"
      priority                = null
      ranges                  = ["0.0.0.0/0"]
      source_tags             = null
      source_service_accounts = null
      target_tags             = null
      target_service_accounts = null
    },
    {
      allow = [{
        ports    = ["22", "3389"]
        protocol = "tcp"
        },
      ]
      deny                    = []
      description             = "Allow IAP Range to access to compute engine"
      direction               = "INGRESS"
      log_config              = null
      name                    = "fw-ingress-allow-iap-${local.vpc_network_name}"
      priority                = null
      ranges                  = ["35.235.240.0/20"] # Identity Aware Proxy CIDR 
      source_tags             = null
      source_service_accounts = null
      target_tags             = null
      target_service_accounts = null
    },
    {
      allow = [{
        ports    = ["80", "443"]
        protocol = "tcp"
        },
      ]
      deny                    = []
      description             = "Allow IAP Range to access to compute engine"
      direction               = "INGRESS"
      log_config              = null
      name                    = "fw-ingress-allow-https-${local.vpc_network_name}"
      priority                = null
      ranges                  = [data.google_compute_subnetwork.my-subnetwork.ip_cidr_range, "10.128.0.0/20"] # Identity Aware Proxy CIDR 
      source_tags             = null
      source_service_accounts = null
      target_tags             = null
      target_service_accounts = null
    },
  ]

  metadata_startup_script = <<SCRIPT
        apt-get -y update
        apt-get -y install nginx
        export HOSTNAME=$(hostname | tr -d '\n')
        export PRIVATE_IP=$(curl -sf -H 'Metadata-Flavor:Google' http://metadata/computeMetadata/v1/instance/network-interfaces/0/ip | tr -d '\n')
        echo "Welcome to $HOSTNAME - $PRIVATE_IP" > /usr/share/nginx/www/index.html
        service nginx start
  SCRIPT

  /*
  # metadata_startup_script = <<SCRIPT
    sudo apt-get remove docker docker-engine docker.io containerd runc
    sudo apt-get update
    sudo apt-get -y install \
        ca-certificates \
        curl \
        gnupg
    sudo mkdir -m 0755 -p /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    echo \
      "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
      "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
      sudo tee /etc/apt/sources.list.d/docker.list > /dev/null 
    sudo apt-get update
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    sudo groupadd docker
    sudo usermod -aG docker $USER
    newgrp docker
    
    alias dk='docker'
    alias dc='docker compose'
    alias p3='python3'
    
    SCRIPT

*/
}
