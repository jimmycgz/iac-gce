/******************************************
	VPC configuration
 *****************************************/
module "vpc" {
  source                                 = "./modules/vpc"
  network_name                           = var.vpc_network_name
  auto_create_subnetworks                = var.auto_create_subnetworks
  routing_mode                           = var.routing_mode
  project_id                             = var.google_project_id
  description                            = var.description
  shared_vpc_host                        = var.shared_vpc_host
  delete_default_internet_gateway_routes = var.delete_default_internet_gateway_routes
  mtu                                    = var.mtu
}

/******************************************
	Subnet configuration
 *****************************************/
module "subnets" {
  source           = "./modules/subnets"
  project_id       = var.google_project_id
  network_name     = module.vpc.network_name
  subnets          = local.subnets
  secondary_ranges = local.secondary_ranges
}


module "vpc_peering" {
  source                    = "terraform-google-modules/network/google//modules/network-peering"
  prefix                    = "vpc-peer" # example: vpc-peer-hub-vpc-prd-vpc
  local_network             = module.vpc.network_self_link
  peer_network              = "https://www.googleapis.com/compute/v1/projects/${var.google_project_id}/global/networks/default"
  export_peer_custom_routes = true
}
