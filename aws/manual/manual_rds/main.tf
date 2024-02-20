data "aws_subnets" "example" {
  filter {
    name   = "tag:subnet"
    values = ["db"]
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
  name       = "main"
  subnet_ids = data.aws_subnets.example.ids
  description = "private postgres subnet"


  tags = {
    Name = "subnet_groups"
    env = "test"
    role = "db"
  }
}
resource "aws_security_group" "security_group_db" {
  name   = "sg_db_postgres_to_all"
  vpc_id = data.aws_vpc.select_vpc.id
  description = "open postgres port"

  ingress {
    protocol  = "tcp"
    from_port = 5432
    to_port   = 5432
    cidr_blocks = [data.aws_vpc.select_vpc.cidr_block]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name  = "sg_postgres"
    env = "stage1"
  }
}
resource "aws_db_instance" "db_instance" {
  allocated_storage = 10
  max_allocated_storage = 100
  storage_type = "gp2"
  engine = "postgres"
  engine_version = "14.8"
  instance_class = "db.t3.small"
  identifier = "testmydatabase"
  db_name = "test"
  username = "testuser"
  password = "testpass"
  apply_immediately = false
  auto_minor_version_upgrade = false
  deletion_protection = false
  multi_az = true
 # parameter_group_name = ""
  publicly_accessible = false

  backup_retention_period = 7
  maintenance_window = "Mon:03:00-Mon:04:00"
  backup_window  = "01:00-03:00"

  vpc_security_group_ids = [aws_security_group.security_group_db.id]
  db_subnet_group_name = aws_db_subnet_group.private_db.name

  skip_final_snapshot = true
  
  tags = {
    Name  = "db_postgres"
    env = "stage1"
    role = "db"
  }
}
resource "aws_db_instance" "db_instance_replica" {
  instance_class       = "db.t3.small"
  identifier = "replicatestmydatabase"
  skip_final_snapshot  = true
  deletion_protection = false
  auto_minor_version_upgrade = false
 # backup_retention_period = 7
  multi_az = false
  replicate_source_db = aws_db_instance.db_instance.identifier
}