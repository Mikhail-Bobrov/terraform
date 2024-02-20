locals {
  user_name =  { for i in var.iam_users : i.user_name => i }
}
resource "aws_iam_user_group_membership" "user_in_group" {
  for_each = local.user_name

  user = each.key
  groups = compact(each.value.user_groups)  ##to ignore empty groups

  depends_on = [aws_iam_user.users , aws_iam_group.iam_groups]
}
resource "aws_iam_user" "users" {
  for_each = local.user_name

  name = each.key
  tags = {
    Name = each.key
    #group = "developer"
   # email = "${var.create_user[count.index]}@${var.email}"
  }
}
#### future ####
# resource "aws_iam_access_key" "users_key" {
#   for_each = local.user_name
#   user = each.key
# }

resource "aws_iam_user_login_profile" "user_login" {
  for_each = local.user_name

  user    = each.key
  password_reset_required = true
  depends_on = [aws_iam_user.users]
  lifecycle {
    ignore_changes = [
      password_length,
      password_reset_required,
    ]
  }
}