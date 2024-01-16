################################################################################
# Resource Group
################################################################################

resource "azurerm_resource_group" "resourcegroup" {
  name     = "minecraftRG"
  location = "Brazil South"
}

################################################################################
# Storage Account
################################################################################

resource "azurerm_storage_account" "mine_storage" {
  name                     = "minestorageplat"
  resource_group_name      = azurerm_resource_group.resourcegroup.name
  location                 = azurerm_resource_group.resourcegroup.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_share" "mine_file_share" {
  name                 = "mineshareplat"
  storage_account_name = azurerm_storage_account.mine_storage.name
  quota                = 5
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
      name                 = "minecraft-volume"
      mount_path           = "/data"
      storage_account_name = azurerm_storage_account.mine_storage.name
      share_name = azurerm_storage_share.mine_file_share.name
      storage_account_key = azurerm_storage_account.mine_storage.primary_access_key
      
    }
  }
}
