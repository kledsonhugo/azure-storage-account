resource "azurerm_resource_group" "rg-staticsite" {
  name     = "rg-staticsite"
  location = "brazilsouth"
}

resource "azurerm_storage_account" "storage_account" {
  name                     = var.storage_account_name
  resource_group_name      = azurerm_resource_group.rg-staticsite.name
  location                 = azurerm_resource_group.rg-staticsite.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"
}

resource "azurerm_storage_account_static_website" "static_website" {
  storage_account_id = azurerm_storage_account.storage_account.id
  index_document     = "index.html"
  error_404_document = "error.html"
}
 
resource "azurerm_storage_blob" "index" {
  name                   = "index.html"
  storage_account_name   = azurerm_storage_account.storage_account.name
  storage_container_name = "$web"
  type                   = "Block"
  content_type           = "text/html"
  source                 = "../app/index.html"
  depends_on             = [azurerm_storage_account_static_website.static_website]
}

resource "azurerm_storage_blob" "error" {
  name                   = "error.html"
  storage_account_name   = azurerm_storage_account.storage_account.name
  storage_container_name = "$web"
  type                   = "Block"
  content_type           = "text/html"
  source                 = "../app/error.html"
  depends_on             = [azurerm_storage_account_static_website.static_website]
}