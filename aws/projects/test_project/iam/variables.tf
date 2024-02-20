variable "region" {
  description = "region name"
  default = "eu-west-1"
}
variable "iam_group" {
  default = [
    # {
    #     group_name = "admin"
    #     group_policy = ["arn:aws:iam::aws:policy/sd","arn:aws:iam::aws:policy/d","arn:aws:iam::aws:policy/gs","arn:aws:iam::aws:policy/z"]
    # },
    # {
    #    group_name = "admin2"
    #    group_policy = []
    # }
  ]
}
variable "iam_users" {
  default = [
    # {
    #     user_name = "user1"
    #     user_groups = ["sys","sys2"]
    # },
    # {
    #    user_name = "user2"
    #    user_groups = []
    # }
  ]
}