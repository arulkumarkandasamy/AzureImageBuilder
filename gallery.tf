resource "azurerm_shared_image_gallery" "main" {
  name                = var.gallery_name
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
}

# --- Linux Definitions ---
resource "azurerm_shared_image" "linux_images" {
  for_each            = toset(["Ubuntu22", "RHEL9", "Debian11", "AlmaLinux9"])
  name                = "hardened-${lower(each.key)}"
  gallery_name        = azurerm_shared_image_gallery.main.name
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  os_type             = "Linux"

  identifier {
    publisher = "Corp"
    offer     = "LinuxServer"
    sku       = lower(each.key)
  }
}

# --- Windows Definitions ---
resource "azurerm_shared_image" "win_images" {
  name                = "hardened-win2022"
  gallery_name        = azurerm_shared_image_gallery.main.name
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  os_type             = "Windows"

  identifier {
    publisher = "Corp"
    offer     = "WindowsServer"
    sku       = "2022-Datacenter"
  }
}