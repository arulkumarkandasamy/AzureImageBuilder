terraform {
  required_providers {
    azurerm = { source = "hashicorp/azurerm", version = "~> 3.0" }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "main" {
  name     = var.rg_name
  location = var.location
  tags     = var.tags
}

# 1. Identity for Image Builder
resource "azurerm_user_assigned_identity" "aib" {
  location            = azurerm_resource_group.main.location
  name                = "id-aib-builder"
  resource_group_name = azurerm_resource_group.main.name
}

# 2. Assign Permissions (Contributor on RG is required for AIB to create temp resources)
resource "azurerm_role_assignment" "aib_contributor" {
  scope                = azurerm_resource_group.main.id
  role_definition_name = "Contributor"
  principal_id         = azurerm_user_assigned_identity.aib.principal_id
}