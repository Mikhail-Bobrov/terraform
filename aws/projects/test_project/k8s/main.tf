module "k8s" {
  source                       = "../../../modules/k8s"
  node_ssh_key_name = var.node_ssh_key_name
  region = var.region
  node_instance_type = var.node_instance_type
  k8s_public_access = var.k8s_public_access
}
