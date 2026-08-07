variable "sub_id" {
  type        = string
  description = "Subscription ID for the Azure account"
}

variable "location" {
  type        = string
  description = "Azure region for the resources"
  default     = "centralus"
}

variable "hubvnet_cidr" {
  type        = string
  description = "CIDR block for the hub virtual network"
  default     = "10.0.0.0/16"
}

variable "spokevnet_cidr" {
  type        = string
  description = "CIDR block for the spoke virtual network"
  default     = "10.1.0.0/16"
}

variable "subnets" {
  description = "Subnet name to address prefix, hub subnets"
  type        = map(string)
  default = {
    AzureFirewallSubnet = "10.0.1.0/26"
    AzureBastionSubnet  = "10.0.2.0/26"
  }
}

variable "workload_subnet_cidr" {
  type        = string
  description = "CIDR block for the workload subnet"
  default     = "10.1.1.0/24"
}

variable "admin_username" {
  type        = string
  description = "Admin username for the virtual machines"
}