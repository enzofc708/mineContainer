################################################################################
# Resource Group
################################################################################

resource "azurerm_resource_group" "resourcegroup" {
  name     = "minecraftRG"
  location = "Brazil South"
}


################################################################################
# Container App
################################################################################

resource "azurerm_container_group" "mineContainer" {
  name                = "mineContainer"
  resource_group_name = azurerm_resource_group.resourcegroup.name
  location            = azurerm_resource_group.resourcegroup.location
  os_type             = "Linux"
  ip_address_type     = "Public"
  container {
    name                  = "minecraft"
    image                 = "itzg/minecraft-server"
    cpu                   = 2
    memory                = 3
    cpu_limit             = 2
    memory_limit          = 3
    environment_variables = { "EULA" = "true" }

    ports {
      port     = 25575
      protocol = "TCP"
    }
    ports {
      port     = 25565
      protocol = "TCP"
    }
    volume {
      name = "minecraft-volume"
      mount_path = "/data"
    }
  }
}
