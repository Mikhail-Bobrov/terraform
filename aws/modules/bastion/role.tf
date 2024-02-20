resource "aws_iam_role" "ec2_role" {
  name = "bastion_${var.name}_Eip"
  
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}
resource "aws_iam_role_policy_attachment" "ec2_attachment" {
  depends_on = [aws_iam_role.ec2_role, aws_iam_policy.bastion_policy] 
  role       = aws_iam_role.ec2_role.name
  policy_arn = aws_iam_policy.bastion_policy.arn
}
resource "aws_iam_instance_profile" "aim_profile" {
  depends_on = [aws_iam_role.ec2_role] 
  name = "bastion_${var.name}_role_profile"
  role = aws_iam_role.ec2_role.name
}
resource "aws_eip" "bastion_public_ip" {
  domain = "vpc"
  tags = {
    Name = "bastion_${var.name}_eip"
    environment = "${var.name}"
    role = "bastion"
  }
}
resource "aws_iam_policy" "bastion_policy" {
  name        = "bastion_${var.name}_eip_policy"
  path        = "/"
  description = "allow allocate eip"

  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "ec2:DescribeAddresses",
                "ec2:AssociateAddress"
            ],
            "Resource": "*"
        }
    ]
})
}
