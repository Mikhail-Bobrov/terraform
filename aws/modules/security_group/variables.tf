variable "region" {
  description = "region name"
  default = "eu-west-1"
}
variable "name" {
  description = "default name for many resources"
  default = "main"
}
variable "env" {
  description = "default env"
  default = "stage"
}
variable "sg_ingress" {
  description = "array for ingress ports like 80 443 etc"
  type    = list(string)
  default = []
}
variable "sg_allow_ssh" {
  description = "allow add ingress"
  default = false
}
variable "sg_allow_ssh_subnet" {
  description = "allow cidr range for ssh ingress"
  default = "0.0.0.0/0"
}
variable "vpc_tag_name" {
  description = "vpc tag name to find it"
  default = "main"
}
variable "sg_ssh_custom_port" {
  description = "custom port for ssh if you desided to change default 22 in your instance"
  default = 22
}
variable "sg_basic_rules" {
  description = "provide to deploy basic rules like different sg with 80 443 ports"
  default = false
}