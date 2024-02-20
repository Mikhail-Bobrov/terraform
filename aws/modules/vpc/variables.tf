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
variable "subnets_public" {
  description = "public subnets ip"
  default = [
    {
         ip_cidr_range = "10.0.0.0/24"
    }
  ]
}
variable "subnets_internal" {
  description = "internal subnets ip"
  default = [
    {
         ip_cidr_range = "10.0.10.0/24"
    }
  ]
}
variable "subnets_private" {
  description = "private subnets ip"
  default = []
}
variable "vpc_tenancy" {
  description = "Dedicated tenancy means you're the only customer running anything on that host. Which is more expensive"
  default = "default"
}
variable "vpc_cidr_block" {
  description = "if you change this you will have to change all subnets and declare it all"
  default = "10.0.0.0/16"
}
# variable "nat_count" {
#   description = "future thin for az by default for 1 region"
#   default = 1
# }
variable "vpc_tag_name" {
  description = "vpc tag name to find it"
  default = "main"
}
variable "project" {
  description = "vpc tag name to find it"
  default = "main"
}
variable "sg_basic_rules" {
  description = "provide to deploy basic rules like different sg with 80 443 ports"
  default = false
}
variable "k8s_network_enable" {
  description = "enable k8s network"
  default = false
}
variable "k8s_vpc_cidr_block" {
  description = "if you change this you will have to change all subnets and declare it all"
  default = "10.1.0.0/19"
}
variable "k8s_subnets_internal" {
  description = "internal  k8s subnets ip"
  default = [
    {
         ip_cidr_range = "10.1.0.0/22"
    },
    {
         ip_cidr_range = "10.1.4.0/22"
    }
  ]
}