variable "vpc_name" {
  description = "vpc name"
}

variable "project" {
  description = "project name id"
}

variable "region" {
  description = "region name"
}

variable "subnets" {
  description = "full description subnets"
  default = []
}

variable "router_name" {
  description = "router name"
}

variable "nat_name" {
  description = "nat name"
}
variable "nat_select_index" {
  description = "nat number what provide index of subnets"
}