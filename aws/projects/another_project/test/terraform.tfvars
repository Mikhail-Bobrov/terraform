# secret_key = "key"
# access_key = "key"
name = "test"
region = "eu-west-2"
env = "preprod"
iam_group = [
    {
        group_name = "test"
        group_policy = ["arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"]
    },
    {
       group_name = "test2"
       group_policy = []
    }
]
iam_users = [
    {
        user_name = "user1"
        user_groups = ["test","test2"]
    },
    {
       user_name = "user2"
       user_groups = ["test"]
    },
    {
       user_name = "user3"
       user_groups = [""] 
    }
]