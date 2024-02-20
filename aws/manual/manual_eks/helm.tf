# provider "helm" {
#   kubernetes {
#     host                   = aws_eks_cluster.eks_cluster.endpoint
#     cluster_ca_certificate = base64decode(aws_eks_cluster.eks_cluster.certificate_authority[0].data)

#     exec {
#       api_version = "client.authentication.k8s.io/v1beta1"
#       args        = ["eks", "get-token", "--cluster-name", aws_eks_cluster.eks_cluster.id]
#       command     = "aws"
#     }
#   }
# }
# resource "helm_release" "karpenter" {
#   namespace        = "kube-system"
#   create_namespace = false

#   name       = "karpenter"
#   chart      = "./karpenter"
#   version    = "v0.33"
#   values = [file("./karpenter/my_val.yaml")]

#   depends_on = [aws_eks_node_group.node_group]
# }
data "kubectl_path_documents" "metric_server" {
    pattern = "./manifests/metrics*.yaml"
}
resource "kubectl_manifest" "metric_server" {
    for_each  = toset(data.kubectl_path_documents.metric_server.documents)
    yaml_body = each.value
    depends_on = [aws_eks_node_group.node_group]
}

data "kubectl_path_documents" "autoscaler" {
    pattern = "./manifests/node_*.yaml"
}
resource "kubectl_manifest" "cluster_autoscaler" {
    for_each  = toset(data.kubectl_path_documents.autoscaler.documents)
    yaml_body = each.value
    depends_on = [aws_eks_node_group.node_group]
}