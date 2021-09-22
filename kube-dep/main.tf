terraform {
  required_providers {
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = ">= 2.0.3"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.1.0"
    }
  }
}

resource "kubernetes_namespace" "devnamespace" {
  metadata {
    name = var.devnamespace
  }
}

resource "kubernetes_deployment" "nginx" {
  metadata {
    name = var.nginx.name
    namespace= kubernetes_namespace.nginx.metadata.0.name
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "test"
      }
    }
    template {
      metadata {
        labels = {
          app  = "test"
        }
      }
      spec {
        container {
          image = var.nginx.image
          name  = var.nginx.containername

          resources {
            limits = {
              memory = "512M"
              cpu = "1"
            }
            requests = {
              memory = "256M"
              cpu = "50m"
            }
          }
        }
      }
    }
  }
}

resource helm_release nginx_ingress {
  name       = "nginx-ingress-controller"

  repository = "https://charts.bitnami.com/bitnami"
  chart      = "nginx-ingress-controller"

  set {
    name  = "service.type"
    value = "ClusterIP"
  }
}

resource "local_file" "kubeconfig" {
  content = var.kubeconfig
  filename = "${path.root}/kubeconfig"
}