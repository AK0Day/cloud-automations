provider "azurerm" {
  features {}
}

variable "location" {
  type    = string
}

variable "resource_group_name" {
  type = string
}

variable "storage_account_name" {
  type = string
}

variable "replication_type" {
  type    = string
  default = "GRS"
}

variable "account_tier" {
  type    = string
  default = "Standard"
}

resource "azurerm_storage_account" "this" {
  name                     = var.storage_account_name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = var.account_tier
  account_replication_type = var.replication_type

  min_tls_version                    = "TLS1_2"
  https_traffic_only_enabled         = true
  allow_nested_items_to_be_public    = false
  public_network_access_enabled      = true

  tags = {
    environment = "dev"
    managed_by  = "terraform"
  }
}
