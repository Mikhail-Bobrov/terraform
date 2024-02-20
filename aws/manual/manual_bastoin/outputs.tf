# output "print_group_name_and_policy" {
#     value = local.group_name
# }
# output "print_user_name" {
#   value = local.user_name
# }
# output "users_first_password" {
#   value = [
#     for i in aws_iam_user_login_profile.user_login :
#     "User name: ${i.user} The first Password was: ${i.password}"
#   ]
#   sensitive = true
# }