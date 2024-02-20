resource "aws_ecr_repository" "main" {
  name                 = "application1"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = false
  }
  tags = {
    Name = "test"
    role = "registry"
    type = "private"
  }
}
resource "aws_ecr_lifecycle_policy" "example" {
  repository = aws_ecr_repository.main.name

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
output registry_url {
  value       = aws_ecr_repository.main.repository_url
}
