resource "azurerm_private_endpoint" "redispep" {
  count               = var.rc_redisc_create && var.rc_enable_private_endpoint ? 1 : 0

  resource_group_name = var.rg_resource_group_name
  location            = var.rg_location

  name                = format("%s-private-endpoint", var.rc_redis_cache_name)
  subnet_id           = data.azurerm_subnet.sql[0].id

  private_service_connection {
    name                           = format("%s-private-endpoint", var.rc_redis_cache_name)
    is_manual_connection           = false
    private_connection_resource_id = azurerm_redis_cache.redis[0].id
    subresource_names              = ["redisCache"]
  }

  private_dns_zone_group {
    name                 = azurerm_redis_cache.redis[0].name
    private_dns_zone_ids = [azurerm_private_dns_zone.dz[0].id]
  }

  tags     = merge({ "ResourceName" = format("%s-private-endpoint", var.rc_redis_cache_name) }, var.tags, )
}
