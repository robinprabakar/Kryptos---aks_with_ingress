resource "azurerm_resource_group" "k8s" {
    name     = var.resource_group_name
    location = var.location
}
resource "azurerm_kubernetes_cluster" "k8s" {
    name                = var.cluster_name
    location            = azurerm_resource_group.k8s.location
    resource_group_name = azurerm_resource_group.k8s.name
    dns_prefix          = var.dns_prefix
    node_resource_group = "${azurerm_resource_group.k8s.name}-nrg"

   default_node_pool {
     name                 = "systempool"
     vm_size              = "Standard_DS2_v2"
     availability_zones   = [1, 2, 3]
     enable_auto_scaling  = true
     max_count            = 2
     min_count            = 1
     os_disk_size_gb      = 30
     type                 = "VirtualMachineScaleSets"
     node_labels = {
       "nodepool-type"    = "system"
       "environment"      = "dev"
       "nodepoolos"       = "linux"
       "app"              = "system-apps" 
     } 
   tags = {
      "nodepool-type"    = "system"
      "environment"      = "dev"
      "nodepoolos"       = "linux"
      "app"              = "system-apps" 
   } 
  }
    identity {
        type = "SystemAssigned"
    }

    azure_policy_enabled = false

    http_application_routing_enabled = false

}
