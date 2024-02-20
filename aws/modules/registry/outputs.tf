output registry_url {
  value  =  { for k, repo in aws_ecr_repository.main : k => repo.repository_url }
}
