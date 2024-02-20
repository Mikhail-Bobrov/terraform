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
variable "image_aim" {
  description = "aim name"
  default = "ami-0ff1c68c6e837b183"
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