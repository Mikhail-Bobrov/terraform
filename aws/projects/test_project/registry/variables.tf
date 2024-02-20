variable "region" {
  description = "region name"
  default = "eu-west-1"
}
variable "reg_name" {
  description = "registry name"
  default = []
}
variable "mutability" {
  description = "image_tag_mutability (MUTABLE and IMMUTABLE)"
  default = "MUTABLE"
}
variable "scanning" {
  description = "scanning image"
  default = false
}
variable "project" {
  description = "project name"
  default = "my_project_number1"
}
variable "env" {
  description = "env of project"
  default = "stage"
}
variable "force_delete" {
  default = false
}