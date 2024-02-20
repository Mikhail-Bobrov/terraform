output "bastion_public_ip" {
    value = aws_eip.bastion_public_ip.public_ip
}