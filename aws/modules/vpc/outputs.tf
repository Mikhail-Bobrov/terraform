output "subnet_internal_cidr" {
  value = aws_subnet.main_internal[*].cidr_block
}
output "subnet_public_cidr" {
  value = aws_subnet.main_public[*].cidr_block
}
output "subnet_private_cidr" {
  value = aws_subnet.main_private[*].cidr_block
}
output "vpc_info" {
  value = aws_vpc.vpc_main.cidr_block
}