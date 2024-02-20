variable "region" {
  description = "region name"
  default = "eu-west-1"
}
variable "name" {
  description = "basic name"
  default = "main"
}
variable "project" {
  description = "project name"
  default = "my_test"
}
variable "env" {
  description = "env name"
  default = "stage"
}
variable "k8s_service_id_range" {
  description = "cidr range for services in cluster"
  default = "192.168.0.0/16"
}
variable "k8s_public_access" {
  default = true
}
variable "k8s_public_access_cidr" {
  description = "cidr range for k8s public access"
  default = "0.0.0.0/0"
}
variable "node_capacity_type" {
  description = "spot or on_demand (upper case)"
  default = "SPOT"
}
variable "node_instance_type" {
  description = "like ec2 instance type"
  default = ["t3.small","t2.small","t3.medium","t2.medium"]
}
variable "node_autoscale_min_size" {
  default = 0
}
variable "node_autoscale_max_size" {
  default = 3
}
variable "node_autoscale_desired_size" {
  default = 1
}
variable "node_autoscale_max_unavailable" {
  default = 1
}
variable "node_disk_root_size" {
  description = "basic root / size"
  default = 20
}
variable "node_ssh_key_name" {
  description = "key for ssh"
  default = ""
}
variable "k8s_addon_metrics_server" {
  default = true
}
variable "k8s_addon_metrics_server_namespace" {
  default = "kube-system"
}
variable "k8s_addon_cluster_autoscaler" {
  default = true
}
variable "k8s_addon_cluster_autoscaler_namespace" {
  default = "kube-system"
}