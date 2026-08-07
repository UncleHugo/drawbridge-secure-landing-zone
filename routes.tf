resource "azurerm_route_table" "spoke_workload" {
  name                = "rt-spoke-workload"
  resource_group_name = azurerm_resource_group.mainRG.name
  location            = azurerm_resource_group.mainRG.location

  bgp_route_propagation_enabled = false

  route {
    name                   = "default-via-firewall"
    address_prefix         = "0.0.0.0/0"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = azurerm_firewall.mainfirewall.ip_configuration[0].private_ip_address
  }
}

resource "azurerm_subnet_route_table_association" "association_spoke_workload" {
  subnet_id      = azurerm_subnet.workload.id
  route_table_id = azurerm_route_table.spoke_workload.id
}