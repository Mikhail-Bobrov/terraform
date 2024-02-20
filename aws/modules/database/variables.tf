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
variable "instance_type" {
  description = "type name"
  default = "db.t2.small"
}
variable "storage_type" {
  description = "gp2 gp3 io"
  default = "gp2"
}
variable "storage_capacity" {
  description = "count Gi storage of storage_type"
  default = "11"
}
variable "storage_capacity_auto" {
  description = "count Gi storage of storage_type over basic storage_capacity"
  default = ""
}
variable "database_type" {
  description = "basic database type for example postgres mysql e t c"
  default = "postgres"
}
variable "database_port" {
  description = "override database default port"
  default = ""
}
variable "database_version" {
  description = "sql version"
  default = "14.7"
}
variable "apply_changes" {
  default = false
}
variable "database_nameid" {
  description = "sql identifier"
  default = "maindatabase"
}
variable "database_master_username" {
  description = "database username"
  default = "testuser"
  sensitive = true
}
variable "database_master_pass" {
  description = "database username"
  default = "testuser"
  sensitive = true
}
variable "database_master_db_name" {
  description = "database pass"
  default = "pass123"
  sensitive = true
}
variable "database_version_upgrade" {
  description = "allow aws minor upgrade  database version"
  default = false
}
variable "deletion_protection" {
  description = "protect database from random delete"
  default = false
}
variable "multi_az" {
  description = "HA for database"
  default = false
}
variable "accesses_to_public" {
  description = "prefered private link to database"
  default = false
}

variable "backup_retention_period" {
  description = "count from 0 to 35 (up to 7 free trial)"
  default = "7"
}
variable "maintenance_window" {
  description = "special format (time for aws  to breake db)"
  default = "Mon:03:00-Mon:04:00"
}
variable "backup_time" {
  description = "window to make backups (time conflict with maintenance_window)"
  default = "01:00-03:00"
}
variable "final_snapshot" {
  description = "snapshot before postgres will be deleted"
  default = false
}
variable "create_replica" {
  default = false
}


