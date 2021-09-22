terraform {

  required_version = ">=0.12"

  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "~>2.0"
    }
  }
  provider "azurerm" {
    features {}
  }
}

resource "azurerm_resource_group" "k8s_resource_group" {
    name     = var.resource_group_name
    location = var.location
}

resource "azurerm_kubernetes_cluster" "k8s_test" {
    name                = var.cluster_name
    location            = azurerm_resource_group.k8s_resource_group.location
    resource_group_name = azurerm_resource_group.k8s_resource_group.name
    dns_prefix          = var.dns_prefix

    default_node_pool {
        name       = "default"
        node_count = 1
        vm_size    = "Standard_D2_v2"
    }

    identity {
        type = "SystemAssigned"
    }

    tags = {
        Environment = "dev"
    }
}

