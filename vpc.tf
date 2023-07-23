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

resource "google_compute_router" "router" {
  name    = var.router_name
  region  = var.region
  network = google_compute_network.my-vpc.name
}

#resource "google_compute_address" "addr1" {
#  name   = "nat-address1"
#  region = var.region
#}

resource "google_compute_router_nat" "my-nat_manual" {
  name   = var.nat_name
  router = google_compute_router.router.name
  region = var.region

  nat_ip_allocate_option = "AUTO_ONLY"  ###"MANUAL_ONLY"
  #nat_ips                = [google_compute_address.addr1.self_link]

  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"
  subnetwork {
    name                    = google_compute_subnetwork.my-subnet-test[var.nat_select_index].name
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
  }
}

resource "google_compute_firewall" "my-firewall" {
  name    = "${(var.firewall_name)}-icmp"
  network = google_compute_network.my-vpc.name

  allow {
    protocol = "icmp"
  }
  source_ranges = ["0.0.0.0/0"]
  priority = 65535
}