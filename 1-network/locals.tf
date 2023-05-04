locals {
  subnets = [
    {
      subnet_name   = "${var.vpc_network_name}-subnet-01"
      subnet_ip     = "10.10.0.0/16"
      subnet_region = "us-central1"
    },
    {
      subnet_name           = "${var.vpc_network_name}-subnet-02"
      subnet_ip             = "10.13.0.0/16"
      subnet_region         = "us-central1"
      subnet_private_access = "true"
      # subnet_flow_logs      = "true"
      description = "This subnet has a description"
    },
    {
      subnet_name   = "${var.vpc_network_name}-subnet-03"
      subnet_ip     = "10.14.0.0/16"
      subnet_region = "us-central1"
      # subnet_flow_logs          = "true"
      # subnet_flow_logs_interval = "INTERVAL_10_MIN"
      # subnet_flow_logs_sampling = 0.7
      # subnet_flow_logs_metadata = "INCLUDE_ALL_METADATA"
    }
  ]
  secondary_ranges = {
    "${var.vpc_network_name}-subnet-01" = [
      {
        range_name    = "subnet-01-pod-cidr"
        ip_cidr_range = "10.11.0.0/24"
      },
      {
        range_name    = "subnet-01-service-cidr"
        ip_cidr_range = "10.12.0.0/24"
      },
    ]
    "${var.vpc_network_name}-subnet-02" = []
  }
}