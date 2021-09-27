variable "node_count" {
    default = 1
}

variable "dns_prefix" {
    default = "k8stest"
}

variable cluster_name {
    default = "k8stest"
}

variable resource_group_name {
    default = "azure-k8stest"
}

variable location {
    default = "Central US"
}

variable storage_account_name {
    description = "Name of storage account"
}

variable container_name {
    description = "Name of container"
}

variable storage_resource_group_name {
    default = "azure-storage"
}

variable devnamespace {
    default = "dev"
}

variable "nginx" {
  type = list(object({
    name    = string
    replicas = number
    image = string
    containername = string
  }))
  default = [
    {
    name    = "nginx"
    replicas = 1
    image = "nginx:1.19.4"
    containername = "nginx"
    }
  ]
}

variable "kubeconfig" {
  type = string
}