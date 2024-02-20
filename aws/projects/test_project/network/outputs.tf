output "subnet_internal_cidr_module" {
  value = module.vpc.subnet_internal_cidr
}
output "subnet_public_cidr_module" {
  value = module.vpc.subnet_public_cidr
}
output "subnet_private_cidr_module" {
  value = module.vpc.subnet_private_cidr
}
output "vpc_tags" {
  value = module.vpc.vpc_info
}