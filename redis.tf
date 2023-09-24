## redis cache
locals {
  redis_family_map = {
    Basic    = "C",
    Standard = "C",
    Premium  = "P"
  }
}

data "azurerm_subnet" "sql" {
  count      = var.rc_redisc_create ? 1 : 0

  name                 = var.sql_vnet_subnet_name
  virtual_network_name = var.nw_virtual_network_name
  resource_group_name  = var.rg_resource_group_name
}

resource "azurerm_redis_cache" "redis" {
  count               = var.rc_redisc_create ? 1 : 0

  resource_group_name = var.rg_resource_group_name
  location            = var.rg_location

  name                            = format("%s", var.rc_redis_cache_name)

  capacity                        = lookup(var.rc_redis_server_settings, "capacity", null)
  family                          = lookup(var.rc_redis_family, var.rc_redis_server_settings.sku_name, null)
  sku_name                        = lookup(var.rc_redis_server_settings, "sku_name", null)
  enable_non_ssl_port             = lookup(var.rc_redis_server_settings, "enable_non_ssl_port", null)
  minimum_tls_version             = lookup(var.rc_redis_server_settings, "minimum_tls_version", null)
  private_static_ip_address       = lookup(var.rc_redis_server_settings, "private_static_ip_address", null)
  public_network_access_enabled   = lookup(var.rc_redis_server_settings, "public_network_access_enabled", null)
  replicas_per_master             = var.rc_redis_server_settings.sku_name == "Premium" ? lookup(var.rc_redis_server_settings, "replicas_per_master") : null
  shard_count                     = var.rc_redis_server_settings.sku_name == "Premium" ? lookup(var.rc_redis_server_settings, "shard_count") : null
  subnet_id                       = var.rc_redis_server_settings.sku_name == "Premium" ? data.azurerm_subnet.sql[0].id : null
  zones                           = var.rc_redis_server_settings.sku_name == "Premium" ? lookup(var.rc_redis_server_settings, "zones") : null

  redis_configuration {
    enable_authentication           = var.rc_redis_server_settings.sku_name == "Premium" ? lookup(var.rc_redis_configuration, "enable_authentication") : true
    maxfragmentationmemory_reserved = var.rc_redis_server_settings.sku_name == "Premium" || var.rc_redis_server_settings.sku_name == "Standard" ? lookup(var.rc_redis_configuration, "maxfragmentationmemory_reserved") : null
    maxmemory_delta                 = var.rc_redis_server_settings.sku_name == "Premium" || var.rc_redis_server_settings.sku_name == "Standard" ? lookup(var.rc_redis_configuration, "maxmemory_delta") : null
    maxmemory_policy                = lookup(var.rc_redis_configuration, "maxmemory_policy", null)
    maxmemory_reserved              = var.rc_redis_server_settings.sku_name == "Premium" || var.rc_redis_server_settings.sku_name == "Standard" ? lookup(var.rc_redis_configuration, "maxmemory_reserved") : null
    notify_keyspace_events          = lookup(var.rc_redis_configuration, "notify_keyspace_events", null)
    rdb_backup_enabled              = var.rc_redis_server_settings.sku_name == "Premium" && var.rc_enable_data_persistence == true ? true : false
    rdb_backup_frequency            = var.rc_redis_server_settings.sku_name == "Premium" && var.rc_enable_data_persistence == true ? var.rc_data_persistence_backup_frequency : null
    rdb_backup_max_snapshot_count   = var.rc_redis_server_settings.sku_name == "Premium" && var.rc_enable_data_persistence == true ? var.rc_data_persistence_backup_max_snapshot_count : null
    rdb_storage_connection_string   = var.rc_redis_server_settings.sku_name == "Premium" && var.rc_enable_data_persistence == true ? azurerm_storage_account.storeacc.0.primary_blob_connection_string : null
  }

  dynamic "patch_schedule" {
    for_each = var.rc_patch_schedule != null ? [var.rc_patch_schedule] : []
    content {
      day_of_week    = var.rc_patch_schedule.day_of_week
      start_hour_utc = var.rc_patch_schedule.start_hour_utc
    }
  }

  lifecycle {
    ignore_changes = [redis_configuration.0.rdb_storage_connection_string]
  }

  tags     = merge({ "ResourceName" = format("%s", var.rc_redis_cache_name) }, var.tags, )
}
