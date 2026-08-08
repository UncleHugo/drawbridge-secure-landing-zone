# Creating Firewall public ip
resource "azurerm_public_ip" "firewall_public_ip" {
  name                = "afw-pip-hub"
  resource_group_name = azurerm_resource_group.mainRG.name
  location            = azurerm_resource_group.mainRG.location
  allocation_method   = "Static"
  sku                 = "Standard"
}

# Creating Firewall policy
resource "azurerm_firewall_policy" "firewall_policy" {
  name                = "fw-policy"
  resource_group_name = azurerm_resource_group.mainRG.name
  location            = azurerm_resource_group.mainRG.location
  sku                 = "Standard"
}

# Creating Firewall rules
resource "azurerm_firewall_policy_rule_collection_group" "app_rules" {
  name               = "rcg-application-rules"
  firewall_policy_id = azurerm_firewall_policy.firewall_policy.id
  priority           = 220

  # Deny gambling 
  application_rule_collection {
    name     = "deny-gambling"
    priority = 100
    action   = "Deny"

    rule {
      name = "block-gambling-sites"
      protocols {
        type = "Http"
        port = 80
      }
      protocols {
        type = "Https"
        port = 443
      }
      source_addresses = ["10.1.0.0/16"]
      web_categories   = ["Gambling"]
    }
  }

  # manage azure management and entra login
  application_rule_collection {
    name     = "allow-azure-management"
    priority = 103
    action   = "Allow"

    rule {
      name = "allow-arm-and-entra"
      protocols {
        type = "Https"
        port = 443
      }
      source_addresses  = ["10.1.0.0/16"]
      destination_fqdns = ["management.azure.com", "login.microsoftonline.com"]
    }
  }

  application_rule_collection {
    name     = "allow-outbound-web"
    priority = 105
    action   = "Allow"

    rule {
      name = "allow-ubuntu"
      protocols {
        type = "Http"
        port = 80
      }
      protocols {
        type = "Https"
        port = 443
      }
      source_addresses  = ["10.1.0.0/16"]
      destination_fqdns = ["*.ubuntu.com", "*.microsoft.com"]
    }
  }
}

# Creating Firewall
resource "azurerm_firewall" "mainfirewall" {
  name                = "afw-hub"
  resource_group_name = azurerm_resource_group.mainRG.name
  location            = azurerm_resource_group.mainRG.location
  sku_name            = "AZFW_VNet"
  sku_tier            = "Standard"
  firewall_policy_id  = azurerm_firewall_policy.firewall_policy.id

  ip_configuration {
    name                 = "fw-ipconfig"
    subnet_id            = azurerm_subnet.firewall.id
    public_ip_address_id = azurerm_public_ip.firewall_public_ip.id
  }
}