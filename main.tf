resource "azurerm_resource_group" "pihole-rg" {
  location = var.resource_group_location
  name     = "${var.resource_prefix}-pihole-rg"
}

resource "azurerm_virtual_network" "pihole-vnet" {
    name                = "${var.resource_prefix}-pihole-vnet"
    location            = azurerm_resource_group.pihole-rg.location
    resource_group_name = azurerm_resource_group.pihole-rg.name
    address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "pihole-subnet" {
    name                 = "${var.resource_prefix}-pihole-subnet"
    resource_group_name  = azurerm_resource_group.pihole-rg.name
    virtual_network_name = azurerm_virtual_network.pihole-vnet.name
    address_prefixes       = ["10.0.0.0/24"]
}

resource "azurerm_container_group" "pihole-containergroup" {
  name                = "${var.resource_prefix}-pihole-containergroup"
  location            = azurerm_resource_group.pihole-rg.location
  resource_group_name = azurerm_resource_group.pihole-rg.name
  ip_address_type     = "Public"
  os_type             = "Linux"
 
  container {
    name   = var.container_name
    image  = var.image_name
    cpu    = var.cpu_core_number
    memory = var.memory_size

    ports {
        port     = var.port_number-1
        protocol = "TCP"
      }
    ports {
        port     = var.port_number-2
        protocol = "TCP"
      }
  }
}