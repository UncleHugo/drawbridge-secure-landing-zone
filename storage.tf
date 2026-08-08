#storage account for drawbridge environment
resource "azurerm_storage_account" "drawbridgestorage" {
  name                     = "stdrawbridgehugo2609" # globally unique
  resource_group_name      = azurerm_resource_group.mainRG.name
  location                 = azurerm_resource_group.mainRG.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  min_tls_version          = "TLS1_2"

  network_rules {
    default_action             = "Deny"
    bypass                     = ["AzureServices"]
    virtual_network_subnet_ids = [azurerm_subnet.workload.id]
  }
}