resource "azurerm_image_builder_template" "windows" {
  name                = "aib-template-win2022"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.aib.id]
  }

  source {
    type      = "PlatformImage"
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-Datacenter"
    version   = "latest"
  }

  # 1. Native Windows Update Customizer
  customize {
    type            = "WindowsUpdate"
    name            = "RunWindowsUpdate"
    search_criteria = "IsInstalled=0"
    filters         = ["exclude:$_.Title -like '*Preview*'", "include:$true"]
  }

  # 2. Hardening Script
  customize {
    type = "PowerShell"
    name = "ApplyHardening"
    inline = [
      file("${path.module}/scripts/harden_windows.ps1")
    ]
  }

  distribute {
    type = "SharedImage"
    gallery_image_id = azurerm_shared_image.win_images.id
    run_output_name  = "build-win2022"
    replication_regions = [var.location]
  }
}