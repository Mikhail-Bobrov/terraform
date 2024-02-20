module "registry" {
  source                       = "../../../modules/registry"
  mutability = var.mutability
  reg_name = var.reg_name
  project = var.project
  env = var.env
  region = var.region
}
