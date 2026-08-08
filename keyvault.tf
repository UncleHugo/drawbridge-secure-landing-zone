data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "drawbridgekeyvault" {
  name                       = "kv-drawbridge-hugo2609" # globally unique, hyphens allowed here
  resource_group_name        = azurerm_resource_group.mainRG.name
  location                   = azurerm_resource_group.mainRG.location
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  sku_name                   = "standard"
  rbac_authorization_enabled = true
  soft_delete_retention_days = 7
  purge_protection_enabled   = false # production environments should true

  network_acls {
    default_action             = "Deny"
    bypass                     = "AzureServices"
    virtual_network_subnet_ids = [azurerm_subnet.workload.id]
  }
}