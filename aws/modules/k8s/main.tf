#data
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
data "aws_subnets" "k8s_subnets" {
  filter {
    name   = "tag:subnet"
    values = ["k8s"]
  }
}
#cluster
data "tls_certificate" "eks" {
  url = aws_eks_cluster.eks_cluster.identity[0].oidc[0].issuer
}
resource "aws_iam_openid_connect_provider" "eks" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.eks.certificates[0].sha1_fingerprint]
  url             = aws_eks_cluster.eks_cluster.identity[0].oidc[0].issuer
}
resource "aws_iam_role" "eks_cluster_role" {
  name = "eks_cluster_${var.name}_${var.env}_role"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}
resource "aws_iam_role_policy_attachment" "eks_cluster_role_attach" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_cluster_role.name
}
resource "aws_eks_cluster" "eks_cluster" {
  name     = "${var.name}_${var.env}"
  version  = "1.27"
  role_arn = aws_iam_role.eks_cluster_role.arn

  kubernetes_network_config {
    service_ipv4_cidr = var.k8s_service_id_range
  }

  vpc_config {
    endpoint_private_access = var.k8s_public_access ? false : true
    endpoint_public_access  = var.k8s_public_access ? true : false
    public_access_cidrs     = [var.k8s_public_access_cidr]
    subnet_ids = data.aws_subnets.k8s_subnets.ids
  }

  depends_on = [aws_iam_role_policy_attachment.eks_cluster_role_attach]
}



#node group
resource "aws_iam_role" "eks_nodes" {
  name = "eks_group_${var.name}_${var.env}_nodes"

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}
resource "aws_iam_role_policy_attachment" "eks_nodes_attach1" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks_nodes.name
}
resource "aws_iam_role_policy_attachment" "eks_nodes_attach2" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks_nodes.name
}
resource "aws_iam_role_policy_attachment" "eks_nodes_attach3" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks_nodes.name
}
resource "aws_eks_node_group" "node_group" {
  cluster_name    = aws_eks_cluster.eks_cluster.name
  node_group_name = "internal_${var.name}_${var.env}_nodes"
  version = aws_eks_cluster.eks_cluster.version
  node_role_arn   = aws_iam_role.eks_nodes.arn

  subnet_ids = data.aws_subnets.k8s_subnets.ids

  capacity_type  = var.node_capacity_type
  instance_types = var.node_instance_type

  scaling_config {
    desired_size = var.node_autoscale_desired_size
    max_size     = var.node_autoscale_max_size
    min_size     = var.node_autoscale_min_size
  }

  update_config {
    max_unavailable = var.node_autoscale_max_unavailable
  }

  labels = {
    role = "k8s"
    k8s = "true"
  }
  tags = {
    Name = "k8s_node"
    role = "k8s"
  }

  launch_template {
    name    = aws_launch_template.node_template.name
    version = aws_launch_template.node_template.latest_version
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_nodes_attach3,
    aws_iam_role_policy_attachment.eks_nodes_attach2,
    aws_iam_role_policy_attachment.eks_nodes_attach1,
  ]
}

resource "aws_launch_template" "node_template" {
  name = "k8s_launch_${var.name}_${var.env}_template"
#    network_interfaces {
#     security_groups = ["sg-0cb510e3c5c1b869c"]
#   }

  block_device_mappings {
  device_name = "/dev/xvda"
  ebs {
    volume_size = var.node_disk_root_size
    volume_type = "gp2"
    delete_on_termination = true
  }
    }

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "k8s_node_${var.env}_${formatdate("DD-MM-HHmm", timestamp())}_${var.name}"
    }
  }
  key_name = var.node_ssh_key_name != "" ? var.node_ssh_key_name : null

    tags = {
      Name = "k8s_node_tmp"
      role = "k8s"
    }
  lifecycle {
    ignore_changes = [
      tag_specifications[0].tags["Name"],
    ]
  }
}