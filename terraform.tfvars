vpc_name      =  "my-vpc-terraform1"
project       =  "irex-cloud-test-2"
region        =  "europe-west1"
subnets = [
  {
    name          = "my-terraform-subnet-external"
    ip_cidr_range = "10.10.20.0/24"
    private_ip_google_access = true
    secondary_ip_ranges = [
      {
        range_name    = "secondary-subnet-other"
        ip_cidr_range = "10.3.0.0/16"
      }
    ]
  },
  {
    name          = "my-terraform-subnet-internal"
    ip_cidr_range = "10.10.21.0/24"
    private_ip_google_access = false
    secondary_ip_ranges = [
      {
        range_name    = "secondary-subnet-service"
        ip_cidr_range = "10.2.0.0/16"
      },
      {
        range_name    = "secondary-subnet-pods"
        ip_cidr_range = "10.1.0.0/16"
      }
    ]
  }
#  {
#    name          = "my-subnet-database"
#    ip_cidr_range = "10.10.22.0/24"
#    private_ip_google_access = false
#    secondary_ip_ranges = [
#      {
#        range_name    = "fill"
#        ip_cidr_range = "10.4.0.0/16"
#      }
#    ]
#  }
]