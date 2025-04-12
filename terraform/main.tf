# main.tf
resource "azurerm_resource_group" "rg" {
  name     = "codecraft-rg"
  location = "eastus"
}

resource "azurerm_container_registry" "acr" {
  name                = "codecraftacr"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "Basic"
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                = "codecraft-aks"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = "codecraftaks"

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_D2_v2"
  }

  identity {
    type = "SystemAssigned"
  }

  role_based_access_control_enabled = true
}
