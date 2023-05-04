locals {
  bu_name         = "hub"
  env             = "global"
  resource_prefix = "${local.bu_name}-${local.env}"

  region     = "us-central1"
  project_id = "devx-jmy-demo" # your project id

  jump_name_linux  = "${local.resource_prefix}-jump-linux-01"
  jump_image_linux = "projects/ubuntu-os-cloud/global/images/family/ubuntu-2004-lts"

  # subnetwork_link_jump   = one(flatten([for vpc in module.subnets : [for f in vpc.subnets : f.self_link if length(regexall(".*jump.*", f.self_link)) > 0]]))
  vpc_network_name          = "dev-bt-demo-vpc"
  vpc_network_name_selflink = "https://www.googleapis.com/compute/v1/projects/devx-jmy-demo/global/networks/dev-bt-demo-vpc"
  vpc_subnetwork_name       = "https://www.googleapis.com/compute/v1/projects/devx-jmy-demo/regions/us-central1/subnetworks/dev-bt-demo-vpc-subnet-01"
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
      ranges                  = ["172.24.0.0/16"]
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
      ranges                  = ["35.235.240.0/20"]
      source_tags             = null
      source_service_accounts = null
      target_tags             = null
      target_service_accounts = null
    },
  ]

  metadata_startup_script = <<SCRIPT
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
}
