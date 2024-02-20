module "vpc" {
  source                       = "../../modules/vpc"
  access_key = var.access_key
  secret_key = var.secret_key
  name = var.name
  env = var.env
  subnets_public = [{ ip_cidr_range = "10.0.150.0/24"}, {ip_cidr_range = "10.0.200.0/24"}]  ##example! this may be indicated as variable
  subnets_internal = [{ ip_cidr_range = "10.0.11.0/24"}, {ip_cidr_range = "10.0.10.0/24"}]  ##example
}

module "security_group" {
  source                       = "../../modules/security_group"
  access_key = var.access_key
  secret_key = var.secret_key
  name = var.name
  env = var.env
  sg_basic_rules = true
}

module "iam" {
  source                      = "../../modules/iam"
  access_key = var.access_key
  secret_key = var.secret_key
  iam_group = var.iam_group
  iam_users = var.iam_users
}
module "bastion" {
  source                      = "../../modules/bastion"
  access_key = var.access_key
  secret_key = var.secret_key
  region = var.region
}