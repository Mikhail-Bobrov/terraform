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