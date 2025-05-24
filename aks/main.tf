provider "azurerm" {
  features {}

  subscription_id = var.subscription_id
}

resource "azurerm_resource_group" "rg" {
  name     = "rg-${var.cluster_name}"
  location = var.location
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.cluster_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = "${var.cluster_name}-dns"

  default_node_pool {
    name                  = "default"
    vm_size               = "Standard_D4s_v3"
    node_count            = 2
    auto_scaling_enabled  = true
    min_count             = 2
    max_count             = 3
    orchestrator_version  = null
    vnet_subnet_id        = null
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin = "azure"
    load_balancer_sku = "standard"
  }

  tags = {
    Environment = "test"
  }
}
