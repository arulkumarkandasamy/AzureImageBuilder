# Local map to handle different Source Images
locals {
  linux_sources = {
    "Ubuntu22"   = { pub = "Canonical", off = "0001-com-ubuntu-server-jammy", sku = "22_04-lts" }
    "RHEL9"      = { pub = "RedHat", off = "RHEL", sku = "9-lvm-gen2" }
    "Debian11"   = { pub = "Debian", off = "debian-11", sku = "11-gen2" }
    "AlmaLinux9" = { pub = "AlmaLinux", off = "AlmaLinux-9", sku = "9-gen2" } # Amazon Linux alternative
  }
}

resource "azurerm_image_builder_template" "linux" {
  for_each            = local.linux_sources
  name                = "aib-template-${lower(each.key)}"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.aib.id]
  }

  source {
    type      = "PlatformImage"
    publisher = each.value.pub
    offer     = each.value.off
    sku       = each.value.sku
    version   = "latest"
  }

  # 1. Native Patching
  customize {
    type = "Shell"
    name = "PatchOS"
    inline = [
      "if [ -f /etc/debian_version ]; then",
      "  export DEBIAN_FRONTEND=noninteractive",
      "  apt-get update && apt-get upgrade -y",
      "elif [ -f /etc/redhat-release ]; then",
      "  dnf update -y --security",
      "fi"
    ]
  }

  # 2. Hardening Script (Inline or Download)
  customize {
    type = "Shell"
    name = "ApplyHardening"
    inline = [
      file("${path.module}/scripts/harden_linux.sh")
    ]
  }

  distribute {
    type = "SharedImage"
    gallery_image_id = azurerm_shared_image.linux_images[each.key].id
    run_output_name  = "build-${lower(each.key)}"
    replication_regions = [var.location]
  }
}