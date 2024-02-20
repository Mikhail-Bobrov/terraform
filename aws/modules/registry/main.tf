locals {
  reg_name_map = { for name in var.reg_name : name => name }
}
output test {
    value = local.reg_name_map
}
resource "aws_ecr_repository" "main" {
  for_each = local.reg_name_map
  name = each.value
  image_tag_mutability = var.mutability
  force_delete = var.force_delete

  image_scanning_configuration {
    scan_on_push = var.scanning
  }
  tags = {
    Name = "${each.value}"
    role = "registry"
    type = "private"
    project = var.project
    env = var.env
  }
}
resource "aws_ecr_lifecycle_policy" "example" {
  for_each = local.reg_name_map
  repository = aws_ecr_repository.main[each.key].name
  depends_on = [aws_ecr_repository.main]
## basic rule
  policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "Expire untagged images older than 20 days"
        selection    = {
          tagStatus      = "untagged"
          countType      = "sinceImagePushed"
          countUnit      = "days"
          countNumber    = 20
        }
        action = {
          type = "expire"
        }
      }
    ]
  })
}