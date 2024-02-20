# parse vars
## it can be done in one go but it will look bad
# group_policy_parsed_example = { for item in flatten([
#     for i in var.iam_group : [
#         for j in setproduct([i.group_name], i.group_policy) : {
#             group_name = j[0]
#             group_policy = j[1]
#         }
#     ]
#   ]) : "${item.group_name}-${item.group_policy}" => i }
locals {
  group_name =  { for i in var.iam_group : i.group_name => i }
  group_policy_parse_without_flatten = [
    for i in var.iam_group : [
        for j in setproduct([i.group_name], i.group_policy) : {
            group_name = j[0]
            group_policy = j[1]
        }
    ]
  ]
  group_policy_parse_flatten = flatten(local.group_policy_parse_without_flatten)
  group_policy_parsed = { for i in local.group_policy_parse_flatten : "${i.group_name}-${i.group_policy}" => i }
}
resource "aws_iam_group" "iam_groups" {
  for_each = local.group_name

  name = each.key
}
resource "aws_iam_group_policy_attachment" "iam_group_atach" {
  for_each = local.group_policy_parsed
  group      = each.value.group_name
  policy_arn = each.value.group_policy
  depends_on = [aws_iam_group.iam_groups]
}
