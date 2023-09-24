## storage account
resource "azurerm_storage_account" "storeacc" {
  count = var.rc_redisc_create && var.rc_enable_data_persistence ? 1 : 0

  resource_group_name      = var.rg_resource_group_name
  location                 = var.rg_location

  name                     = format("%s", var.rc_redis_storage_account_name)

  account_tier             = lookup(var.rc_data_persistence_storage, "account_tier", null)
  account_replication_type = lookup(var.rc_data_persistence_storage, "account_replication_type", null)
  account_kind             = lookup(var.rc_data_persistence_storage, "account_kind", null)

  tags     = merge({ "ResourceName" = format("%s", var.rc_redis_storage_account_name) }, var.tags, )
}

## storage container
resource "azurerm_storage_container" "stct" {
  count = var.rc_redisc_create && var.rc_enable_data_persistence ? 1 : 0

  name                  = format("%s", var.rc_redis_storage_container_name)
  storage_account_name  = azurerm_storage_account.storeacc[0].name
  container_access_type = var.rc_container_access_type
}
