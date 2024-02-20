module "bastion" {
  source                       = "../../../modules/bastion"
  name = var.name
  region = var.region
  project = var.project
}