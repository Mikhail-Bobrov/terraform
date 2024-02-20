name = "test"
region = "eu-west-2"
project = "my_test"
env = "stage3"
sg_basic_rules = true
k8s_network_enable = true
k8s_vpc_cidr_block = "10.1.0.0/19"
vpc_cidr_block = "10.0.0.0/22"
k8s_subnets_internal = [
  {
     ip_cidr_range = "10.1.0.0/22"
  },
  {
     ip_cidr_range = "10.1.4.0/22"
  }
]
subnets_public = [
    {
         ip_cidr_range = "10.0.1.0/25"
    },
    {
         ip_cidr_range = "10.0.1.128/25"
    }
  ]

subnets_internal = [
    {
         ip_cidr_range = "10.0.2.0/25"
    },
    {
         ip_cidr_range = "10.0.2.128/25"
    }
  ]
subnets_private = [
    {
        ip_cidr_range = "10.0.3.0/25"
    },
    {
        ip_cidr_range = "10.0.3.128/25"
    }
]