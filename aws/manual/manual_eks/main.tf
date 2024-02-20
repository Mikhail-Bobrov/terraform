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
  name = "eks-cluster-test"

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
  name     = "test_eks"
  version  = "1.27"
  role_arn = aws_iam_role.eks_cluster_role.arn

  kubernetes_network_config {
    service_ipv4_cidr = "192.168.0.0/16"
  }

  vpc_config {
    endpoint_private_access = false
    endpoint_public_access  = true
    public_access_cidrs     = ["0.0.0.0/0"]
    subnet_ids = ["subnet-04e52f7a1d2bf30b3", "subnet-0a9b48b321e36a851"]
  }

  depends_on = [aws_iam_role_policy_attachment.eks_cluster_role_attach]
}



#node group
resource "aws_iam_role" "eks_nodes" {
  name = "eks_group_nodes"

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
  node_group_name = "internal_nodes"
  version = aws_eks_cluster.eks_cluster.version
  node_role_arn   = aws_iam_role.eks_nodes.arn

  subnet_ids = ["subnet-04e52f7a1d2bf30b3", "subnet-0a9b48b321e36a851"]

  capacity_type  = "SPOT"
  instance_types = ["t3.small"]

  scaling_config {
    desired_size = 1
    max_size     = 3
    min_size     = 0
  }

  update_config {
    max_unavailable = 1
  }

  labels = {
    role = "kubernetes"
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
  name = "k8s_node_template"
#    network_interfaces {
#     security_groups = ["sg-0cb510e3c5c1b869c"]
#   }

  block_device_mappings {
  device_name = "/dev/xvda"
  ebs {
    volume_size = 30
    volume_type = "gp2"
    delete_on_termination = true
  }
    }

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "k8s_node_${formatdate("DD-MM-HHmm", timestamp())}"
    }
  }
  key_name = "test"

    tags = {
      Name = "k8s_node_tmp"
    }
  lifecycle {
    ignore_changes = [
      tag_specifications[0].tags["Name"],
    ]
  }
}