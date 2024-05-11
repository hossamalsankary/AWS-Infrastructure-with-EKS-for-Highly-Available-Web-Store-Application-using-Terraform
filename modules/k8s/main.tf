data "aws_eks_cluster_auth" "cluster" {
  name = var.cluster_name
}

provider "helm" {
  kubernetes {
    host                   = var.cluster_endpoint
    cluster_ca_certificate = base64decode(var.cluster_certificate_authority)
    token                  = data.aws_eks_cluster_auth.cluster.token
  }

}
provider "kubernetes" {
    host                   = var.cluster_endpoint
    cluster_ca_certificate = base64decode(var.cluster_certificate_authority)
    token                  = data.aws_eks_cluster_auth.cluster.token
}
resource "helm_release" "aws_ebs_csi_driver" {
  name       = "aws-ebs-csi-driver"
  repository = "https://kubernetes-sigs.github.io/aws-ebs-csi-driver"
  chart      = "aws-ebs-csi-driver"

  namespace = "kube-system"

  set {
    name  = "enableVolumeScheduling"
    value = "true"
  }

  set {
    name  = "enableVolumeResizing"
    value = "true"
  }

  set {
    name  = "enableVolumeSnapshot"
    value = "true"
  }
}
resource "helm_release" "nginx_ingress" {
  name       = "nginx-ingress-controller"

  repository = "https://charts.bitnami.com/bitnami"
  chart      = "nginx-ingress-controller"

  set {
    name  = "service.type"
    value = "ClusterIP"
  }
}

resource "kubernetes_namespace" "grafana" {
  count = 1
  metadata {
    name = var.namespace_grafana
  }
}

resource "kubernetes_namespace" "prometheus" {
  count = 1

  metadata {
    name = var.namespace_prometheus
  }
}

resource "helm_release" "prometheus" {
  depends_on = [ kubernetes_namespace.prometheus ]
  count      = var.enabled ? 1 : 0
  name       = var.helm_chart_prometheus_name
  chart      = var.helm_chart_prometheus_release_name
  repository = var.helm_chart_prometheus_repo
  namespace  = var.namespace_prometheus

  values = [

    yamlencode(var.settings_prometheus)
  ]

}

resource "helm_release" "grafana" {
  depends_on = [ kubernetes_namespace.grafana ]
  count      = var.enabled ? 1 : 0
  name       = var.helm_chart_grafana_name
  chart      = var.helm_chart_grafana_release_name
  repository = var.helm_chart_grafana_repo
  namespace  = var.namespace_grafana

  set {
    name  = "adminPassword"
    value = "admin"
  }

  values = [
    file("${path.module}/grafana.yaml"),
    yamlencode(var.settings_grafana)
  ]

}




