variable "vpc_name" {
  description = "vpc name"
}

variable "project" {
  description = "project name id"
}

variable "region" {
  description = "region name"
}

#variable "cluster_cidr_range" {
#  description = "cide block range (example 10.10.10.10/24)"
#}

#variable "secondary_ip_ranges" {
#  description = "cidr block range for second subnet"
#}

variable "subnets" {
  description = "full description subnets"
  default = []
}