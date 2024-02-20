variable "access_key" {
  description = "accece key for terraform"
}
variable "secret_key" {
  description = "secret key for terraform"
}
variable "region" {
  description = "region name"
  default = "eu-west-1"
}
variable "name" {
  description = "default name for all resource"
  default = "main"
}
variable "env" {
  description = "default name for env"
  default = "stage"
}
variable "sg_ingress" {
  description = "ingress port for sg resource"
  type    = list(string)
  default = []
}
variable "sg_allow_ssh" {
  description = "default name for all resource"
  default = false
}
variable "sg_allow_ssh_subnet" {
  description = "default name for all resource"
  default = "0.0.0.0/0"
}
variable "vpc_tag_name" {
  description = "default name for all resource"
  default = "main"
}
variable "sg_ssh_custom_port" {
  description = "default name for all resource"
  default = 22
}
variable "sg_basic_rules" {
  description = "default name for all resource"
  default = false
}
