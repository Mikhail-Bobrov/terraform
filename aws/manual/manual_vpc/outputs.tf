output "subnet_internal_cidr" {
  value = aws_subnet.main-internal[*].cidr_block
}
output "subnet_public_cidr" {
  value = aws_subnet.main-public[*].cidr_block
}
output "subnet_private_cidr" {
  value = aws_subnet.main-private[*].cidr_block
}