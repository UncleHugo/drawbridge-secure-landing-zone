resource "azurerm_role_assignment" "vm_storage" {
  scope                = azurerm_storage_account.drawbridgestorage.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_linux_virtual_machine.workload.identity[0].principal_id
}

resource "azurerm_role_assignment" "vm_kv_secrets" {
  scope                = azurerm_key_vault.drawbridgekeyvault.id
  role_definition_name = "Key Vault Secrets Officer"
  principal_id         = azurerm_linux_virtual_machine.workload.identity[0].principal_id
}