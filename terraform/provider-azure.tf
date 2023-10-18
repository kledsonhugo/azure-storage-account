terraform {

  required_providers {

    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }

  }

  backend "azurerm" {
    resource_group_name  = "tfstate"
    storage_account_name = "stracctstaticsite"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }

}

provider "azurerm" {
  features {}
  alias = "cloud"
}

resource "azurerm_resource_group" "rg-staticsite" {
  provider = azurerm.cloud
  name     = "rg-staticsite"
  location = "eastus"
}

resource "azurerm_storage_account" "tfstate" {
  provider                 = azurerm.cloud
  name                     = "tfstate"
  resource_group_name      = azurerm_resource_group.rg-staticsite.name
  location                 = azurerm_resource_group.rg-staticsite.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  allow_nested_items_to_be_public = false
}

resource "azurerm_storage_container" "tfstate" {
  provider              = azurerm.cloud
  name                  = "tfstate"
  storage_account_name  = azurerm_storage_account.tfstate.name
  container_access_type = "private"
}