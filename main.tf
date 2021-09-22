terraform {
  required_providers {
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = ">= 2.0.3"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "2.42"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.1.0"
    }
  }
  backend "azurerm" {
    resource_group_name = var.storage_resource_group_name
    storage_account_name = var.storage_account_name
    container_name = var.container_name
    key = var.storage_key
    access_key = var.storgae_account_access_key
  }
}

data "azurerm_kubernetes_cluster" "k8s_test" {
  depends_on          = [module.aks-cluster] # refresh cluster state before reading
  name                = var.cluster_name
}

provider "kubernetes" {
  host                   = data.azurerm_kubernetes_cluster.k8s_test.kube_config.0.host
  client_certificate     = base64decode(data.azurerm_kubernetes_cluster.k8s_test.kube_config.0.client_certificate)
  client_key             = base64decode(data.azurerm_kubernetes_cluster.k8s_test.kube_config.0.client_key)
  cluster_ca_certificate = base64decode(data.azurerm_kubernetes_cluster.k8s_test.kube_config.0.cluster_ca_certificate)
}

provider "helm" {
  kubernetes {
    host                   = data.azurerm_kubernetes_cluster.k8s_test.kube_config.0.host
    client_certificate     = base64decode(data.azurerm_kubernetes_cluster.k8s_test.kube_config.0.client_certificate)
    client_key             = base64decode(data.azurerm_kubernetes_cluster.k8s_test.kube_config.0.client_key)
    cluster_ca_certificate = base64decode(data.azurerm_kubernetes_cluster.k8s_test.kube_config.0.cluster_ca_certificate)
  }
}

provider "azurerm" {
  features {}
}

module "k8s-cluster" {
  source       = "./cluster"
  cluster_name = var.cluster_name
  location     = var.location
}

module "kubernetes-config" {
  depends_on   = [module.aks-cluster]
  source       = "./kube-dep"
  cluster_name = var.cluster_name
  kubeconfig   = data.azurerm_kubernetes_cluster.k8s_test.kube_config_raw
}