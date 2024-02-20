locals {
    default_database_ports = {
    aurora  = 3306
    aurora-mysql = 3306
    aurora-postgresql = 5432
    mariadb  = 3306
    mysql  = 3306
    postgres = 5432
    sqlserver = 1433
    }
}
data "aws_subnets" "example" {
  filter {
    name   = "tag:subnet"
    values = ["private"]
  }
}
data "aws_vpc" "select_vpc" {
  filter {
    name   = "tag:Name"
    values = ["vpc-*"]
  }
  filter {
    name   = "tag:role"
    values = ["vpc"]
  }
}
resource "aws_db_subnet_group" "private_db" {
  name       = "${var.database_type}_${var.name}_subnet"
  subnet_ids = data.aws_subnets.example.ids
  description = "private ${var.database_type} subnet"


  tags = {
    Name = "subnet_${var.name}"
    env = "${var.env}"
    role = "db"
  }
}
resource "aws_security_group" "security_group_db" {
  name   = "sg_db_${var.database_type}_to_all"
  vpc_id = data.aws_vpc.select_vpc.id
  description = "open ${var.database_type} port"

  ingress {
    protocol  = "tcp"
    from_port = var.database_port == "" ? local.default_database_ports[var.database_type] : var.database_port
    to_port   = var.database_port == "" ? local.default_database_ports[var.database_type] : var.database_port
    cidr_blocks = [data.aws_vpc.select_vpc.cidr_block]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name  = "sg_${var.database_type}"
    env = "${var.env}"
  }
}
resource "aws_db_instance" "db_instance" {
  depends_on = [aws_security_group.security_group_db, aws_db_subnet_group.private_db] 
  allocated_storage = var.storage_capacity
  max_allocated_storage = var.storage_capacity_auto == "" ? null : var.storage_capacity_auto
  storage_type = var.storage_type
  engine = var.database_type
  engine_version = var.database_version
  instance_class = var.instance_type
  identifier = var.database_nameid
  db_name = var.database_master_db_name
  username = var.database_master_username
  password = var.database_master_pass
  apply_immediately = var.apply_changes
  auto_minor_version_upgrade = var.database_version_upgrade
  deletion_protection = var.deletion_protection
  multi_az = var.multi_az
 # parameter_group_name = ""
  publicly_accessible = var.accesses_to_public

  backup_retention_period = var.backup_retention_period
  maintenance_window = var.maintenance_window
  backup_window  = var.backup_time

  vpc_security_group_ids = [aws_security_group.security_group_db.id]
  db_subnet_group_name = aws_db_subnet_group.private_db.name

  skip_final_snapshot = var.final_snapshot
  
  tags = {
    Name  = "db_${var.database_type}"
    env = "${var.env}"
    role = "db"
    db = "master"
  }
}
resource "aws_db_instance" "db_instance_replica" {
  count = var.create_replica ? 1 : 0
  depends_on = [aws_db_instance.db_instance]
  instance_class  = var.instance_type
  identifier = "${var.database_nameid}replica"
#   skip_final_snapshot  = true
#   deletion_protection = false
#   auto_minor_version_upgrade = false
 # backup_retention_period = 7
  multi_az = false
  replicate_source_db = aws_db_instance.db_instance.identifier
  tags = {
    Name  = "db_${var.database_type}"
    env = "${var.env}"
    role = "db"
    db = "replica"
  }
}