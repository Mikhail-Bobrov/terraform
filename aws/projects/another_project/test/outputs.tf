output "subnet_internal_cidr_module" {
  value = module.vpc.subnet_internal_cidr
}
output "subnet_public_cidr_module" {
  value = module.vpc.subnet_public_cidr
}
output "subnet_private_cidr_module" {
  value = module.vpc.subnet_private_cidr
}
output "vpc_id" {
  value = module.security_group.print_vpc_data
}
output "users_name" {
  value = module.iam.print_user_name
}
output "users_first_password" {
  value = module.iam.users_first_password
  sensitive = true
}