module "database" {
  source                       = "../../../modules/database"
  #storage_capacity_auto = var.storage_capacity_auto
  storage_capacity = var.storage_capacity
  database_type = var.database_type
  database_version = var.database_version
  database_port = var.database_port
  multi_az = var.multi_az
}
