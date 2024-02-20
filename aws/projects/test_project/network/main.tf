module "vpc" {
  source    = "../../../modules/vpc"
  name = var.name
  env = var.env
  region = var.region
  subnets_public = var.subnets_public
  subnets_internal = var.subnets_internal
  subnets_private = var.subnets_private
  project = var.project
  sg_basic_rules = var.sg_basic_rules
  vpc_cidr_block = var.vpc_cidr_block
  k8s_network_enable = var.k8s_network_enable
  k8s_vpc_cidr_block = var.k8s_vpc_cidr_block
  k8s_subnets_internal = var.k8s_subnets_internal
}
