resource "azurerm_resource_group" "rg-staticsite" {
  provider = azurerm.azure
  name     = "rg-staticsite"
  location = "eastus"
}
 
resource "azurerm_storage_account" "stracctstaticsite" {
  provider                 = azurerm.azure
  name                     = var.stracctstaticsite
  resource_group_name      = azurerm_resource_group.rg-staticsite.name
  location                 = "eastus"
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"
  static_website {
    index_document     = "index.html"
    error_404_document = "error.html"
  }
}
 
resource "azurerm_storage_blob" "index" {
  provider               = azurerm.azure
  name                   = "index.html"
  storage_account_name   = azurerm_storage_account.stracctstaticsite.name
  storage_container_name = "$web"
  type                   = "Block"
  content_type           = "text/html"
  source                 = "../app/index.html"
}

resource "azurerm_storage_blob" "error" {
  provider               = azurerm.azure
  name                   = "error.html"
  storage_account_name   = azurerm_storage_account.stracctstaticsite.name
  storage_container_name = "$web"
  type                   = "Block"
  content_type           = "text/html"
  source                 = "../app/error.html"
}