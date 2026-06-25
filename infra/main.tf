resource "azurerm_resource_group" "rg" {
    name = "heartfelt-rg"
    location = "canada central"
}

resource "azurerm_container_registry" "acr" {
  name                = "heartfeltacr12345"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "Basic"
  admin_enabled       = true
}


resource "azurerm_kubernetes_cluster" "aks" {
  name                = "heartfelt-aks"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          =  "heartfelt"

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_D2ps_v6"
  }

  identity {
    type = "SystemAssigned"
  }
}