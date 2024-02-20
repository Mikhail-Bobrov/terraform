variable "region" {
  description = "region name"
  default = "eu-west-1"
}
variable "image_aim" {
  description = "aim name"
  default = "ami-0b7c168be68b67913"
}
variable "instance_type" {
  description = "type name"
  default = "t2.micro"
}
variable "instance_market" {
  description = "instance type"
  default = "spot"
}
variable "min_size" {
  description = "min_size number"
  default = 1
}
variable "max_size" {
  description = "max_size number"
  default = 1
}
variable "desired_capacity" {
  description = "desired_capacity number (current size)"
  default = 1
}
variable "name" {
  description = "basic name"
  default = "main"
}
variable "sg_tag_name" {
  description = "guess tag name"
  default = "sg*ssh*"
}
variable "subnet_tag_name" {
  description = "guess tag name"
  default = "public"
}
variable "ssh_port" {
  description = "chose ssh port"
  default = 22
}
variable "ssh_cidr" {
  description = "chose cidr block"
  default = "0.0.0.0/0"
}
variable "project" {
  description = "project name"
  default = "my_test"
}