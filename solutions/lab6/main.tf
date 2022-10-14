resource "azurerm_resource_group" "resgrp" {
  name     = "RG_AppGtw"
  location = "westeurope"
}

resource "azurerm_virtual_network" "qavnet" {
  name                = "VNet"
  resource_group_name = azurerm_resource_group.resgrp.name
  location            = azurerm_resource_group.resgrp.location
  address_space       = ["10.21.0.0/16"]
}

resource "azurerm_subnet" "frontend" {
  name                 = "AGSubnet"
  resource_group_name  = azurerm_resource_group.resgrp.name
  virtual_network_name = azurerm_virtual_network.qavnet.name
  address_prefixes     = ["10.21.0.0/24"]
}

resource "azurerm_subnet" "backend" {
  name                 = "BackendSubnet"
  resource_group_name  = azurerm_resource_group.resgrp.name
  virtual_network_name = azurerm_virtual_network.qavnet.name
  address_prefixes     = ["10.21.1.0/24"]
}

resource "azurerm_public_ip" "pubip" {
  name                = "AGPublicIPAddress"
  resource_group_name = azurerm_resource_group.resgrp.name
  location            = azurerm_resource_group.resgrp.location
  allocation_method   = "Static"
  sku                 = "Standard"
}



resource "azurerm_application_gateway" "network" {
  name                = "AppGateway"
  resource_group_name = azurerm_resource_group.resgrp.name
  location            = azurerm_resource_group.resgrp.location

  sku {
    name     = "Standard_v2"
    tier     = "Standard_v2"
    capacity = 2
  }

  gateway_ip_configuration {
    name      = "my-gateway-ip-configuration"
    subnet_id = azurerm_subnet.frontend.id
  }

  frontend_port {
    name = var.frontend_port_name
    port = 80
  }

  frontend_ip_configuration {
    name                 = var.frontend_ip_configuration_name
    public_ip_address_id = azurerm_public_ip.pubip.id
  }

  backend_address_pool {
    name = var.backend_address_pool_name
  }

  backend_http_settings {
    name                  = var.http_setting_name
    cookie_based_affinity = "Disabled"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 60
  }

  http_listener {
    name                           = var.listener_name
    frontend_ip_configuration_name = var.frontend_ip_configuration_name
    frontend_port_name             = var.frontend_port_name
    protocol                       = "Http"
  }

  request_routing_rule {
    name                       = var.request_routing_rule_name
    rule_type                  = "Basic"
    http_listener_name         = var.listener_name
    backend_address_pool_name  = var.backend_address_pool_name
    backend_http_settings_name = var.http_setting_name
  }
}

resource "azurerm_network_interface" "nic" {
  count = 2
  name                = "nic-${count.index+1}"
  location            = azurerm_resource_group.resgrp.location
  resource_group_name = azurerm_resource_group.resgrp.name

  ip_configuration {
    name                          = "nic-ipconfig-${count.index+1}"
    subnet_id                     = azurerm_subnet.backend.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_network_interface_application_gateway_backend_address_pool_association" "nic-assoc01" {
  count = 2
  network_interface_id    = azurerm_network_interface.nic[count.index].id
  ip_configuration_name   = "nic-ipconfig-${count.index+1}"
  backend_address_pool_id = azurerm_application_gateway.network.backend_address_pool[0].id
}
