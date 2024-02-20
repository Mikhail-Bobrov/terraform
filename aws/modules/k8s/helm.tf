provider "helm" {
  kubernetes {
    host                   = aws_eks_cluster.eks_cluster.endpoint
    cluster_ca_certificate = base64decode(aws_eks_cluster.eks_cluster.certificate_authority[0].data)

    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      args        = ["eks", "get-token", "--cluster-name", aws_eks_cluster.eks_cluster.id]
      command     = "aws"
    }
  }
}
resource "helm_release" "metrics_server" {
  count = var.k8s_addon_metrics_server ? 1 : 0
  namespace        = var.k8s_addon_metrics_server_namespace
  create_namespace = false

  name       = "metrics-server"
  chart      = "${path.module}/manifests/metrics-server"
  version    = "3.11.0"
  values = [file("${path.cwd}/metrics_server.yaml")]
  depends_on = [aws_eks_node_group.node_group]
}

# resource "helm_release" "cluster_autoscaler" {
#   count = var.k8s_addon_cluster_autoscaler ? 1 : 0
#   namespace        = var.k8s_addon_cluster_autoscaler_namespace
#   create_namespace = false

#   name       = "cluster-autoscaler"
#   chart      = "${path.module}/manifests/cluster-autoscaler"
#   version    = "1.29.0"
#   values = [
#     file("${path.cwd}/cluster_autoscaler.yaml"),
#     (templatefile("${path.module}/manifests/cluster-autoscaler/default_override.yaml", {
#     iam_role = aws_iam_role.eks_cluster_autoscaler.arn
#     cluster_name1 = var.name
#     cluster_name2 = var.env
#   }))
#   ]
#   depends_on = [aws_eks_node_group.node_group]
# }