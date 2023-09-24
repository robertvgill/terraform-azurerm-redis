resource "azurerm_redis_firewall_rule" "redisfw" {
  for_each            = var.rc_redisc_create != false && var.rc_firewall_rules != null ? { for k, v in var.rc_firewall_rules : k => v if v != null } : {}
  name                = format("%s", each.key)

  resource_group_name = var.rg_resource_group_name
  redis_cache_name    = element([for n in azurerm_redis_cache.redis : n.name], 0)

  start_ip            = each.value["start_ip"]
  end_ip              = each.value["end_ip"]
}
