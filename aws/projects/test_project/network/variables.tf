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
  default = "stage1"
}
variable "project" {
  description = "project name"
  default = "main"
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
#     {
#         ip_cidr_range = "10.0.20.0/24"
#     }
}
variable "vpc_tenancy" {
  description = "tenancy default"
  default = "default"
}
variable "vpc_cidr_block" {
  description = "cidr_block default"
  default = "10.0.0.0/16"
}
variable "nat_count" {
  description = "nat count "
  default = "1"
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