## vnet
data "azurerm_virtual_network" "vnet" {
  count               = var.rc_redisc_create && var.rc_enable_private_endpoint ? 1 : 0

  name                 = var.nw_virtual_network_name
  resource_group_name  = var.rg_resource_group_name
}

resource "azurerm_private_dns_zone" "dz" {
  count               = var.rc_redisc_create && var.rc_enable_private_endpoint ? 1 : 0

  name                = var.rc_private_dns_zone_name
  resource_group_name = var.rg_resource_group_name
//  tags                = merge({ "ResourceName" = format("%s", lower(var.rc_private_dns_zone_name)) }, var.tags, )
}

resource "azurerm_private_dns_zone_virtual_network_link" "dzvlink" {
  count                 = var.rc_redisc_create && var.rc_enable_private_endpoint ? 1 : 0

  name                  = lower("${var.nw_virtual_network_name}-link")
  resource_group_name   = var.rg_resource_group_name
  virtual_network_id    = data.azurerm_virtual_network.vnet[0].id
  private_dns_zone_name = azurerm_private_dns_zone.dz[0].name
  tags                  = merge({ "ResourceName" = format("%s", lower("${var.rc_private_dns_zone_name}-link")) }, var.tags, )
}
