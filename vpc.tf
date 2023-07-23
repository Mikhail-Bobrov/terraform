resource "google_compute_network" "my-vpc" {
  project                 = var.project
  name                    = "${(var.vpc_name)}-vpc"
  auto_create_subnetworks = false
  mtu                     = 1460
}

resource "google_compute_subnetwork" "my-subnet-test" {
  name          = "${var.subnets[count.index].name}"
  count         = length(var.subnets)
  private_ip_google_access = "${var.subnets[count.index].private_ip_google_access}"
  ip_cidr_range = var.subnets[count.index].ip_cidr_range
  region        = var.region
  network       = google_compute_network.my-vpc.name
  
  dynamic "secondary_ip_range" {
    for_each = var.subnets[count.index].secondary_ip_ranges
    content {
      range_name    = secondary_ip_range.value.range_name
      ip_cidr_range = secondary_ip_range.value.ip_cidr_range
    }
  }
}