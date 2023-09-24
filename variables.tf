## subscription
variable "subscription_id" {
description = "The Subscription ID which should be used."
type        = string
default     = null
}

## naming
variable "department" {
  description = "Specifies the name of the department."
  type        = list(string)
  default     = []
}

variable "projectname" {
  description = "Specifies the name of the project."
  type        = list(string)
  default     = []
}

variable "environment" {
  description = "Specifies the name of the environment."
  type        = list(string)
  default     = []
}

variable "region_mapping" {
  description = "Specifies the name of the region."
  type        = list(string)
  default     = []
}

## resource group
variable "rg_resource_group_name" {
  description = "The name of the resource group in which to create the storage account."
  type        = string
  default     = null
}

variable "rg_location" {
  description = "Specifies the supported Azure location where the resource should be created."
  type        = string
  default     = null
}

## redis cache
variable "rc_redisc_create" {
  description = "Controls if redis cache should be created."
  type        = bool
}

variable "rc_redis_cache_name" {
  description = "Redis Cache Name."
  default     = null
}

variable "rc_redis_family" {
  type        = map(any)
  description = "The SKU family/pricing group to use. Valid values are `C` (for `Basic/Standard` SKU family) and `P` (for `Premium`)."
  default = {
    Basic    = "C"
    Standard = "C"
    Premium  = "P"
  }
}

variable "rc_redis_server_settings" {
  type = object({
    capacity                      = number
    sku_name                      = string
    enable_non_ssl_port           = bool
    minimum_tls_version           = string
    private_static_ip_address     = string
    public_network_access_enabled = bool
    replicas_per_master           = number
    shard_count                   = number
    zones                         = list(string)
  })
  default     = null
}

variable "rc_patch_schedule" {
  type = object({
    day_of_week    = string
    start_hour_utc = number
  })
  default     = null
}

variable "rc_redis_configuration" {
  type = object({
    enable_authentication           = bool
    maxmemory_reserved              = number
    maxmemory_delta                 = number
    maxmemory_policy                = string
    maxfragmentationmemory_reserved = number
    notify_keyspace_events          = string
  })
  default     = null
}

variable "rc_firewall_rules" {
  description = "Range of IP addresses to allow firewall connections."
  type = map(object({
    start_ip = string
    end_ip   = string
  }))
  default = null
}

## redis storage account
variable "rc_redis_storage_account_name" {
  description = "The name of the storage account name for Redis."
  default     = null
}

variable "rc_enable_data_persistence" {
  description = "Enable or disable Redis Database Backup. Only supported on Premium SKU's."
  default     = false
}

variable "rc_data_persistence_storage" {
  type = object({
    account_tier              = string
    account_replication_type  = string
    account_kind              = string
  })
  default     = null
}

variable "rc_data_persistence_backup_frequency" {
  description = "The Backup Frequency in Minutes. Only supported on Premium SKU's. Possible values are: `15`, `30`, `60`, `360`, `720` and `1440`."
  default     = 60
}

variable "rc_data_persistence_backup_max_snapshot_count" {
  description = "The maximum number of snapshots to create as a backup. Only supported for Premium SKU's."
  default     = 1
}

variable "rc_enable_private_endpoint" {
  description = "Manages a Private Endpoint to Azure database for Redis."
}

variable "rc_private_dns_zone_name" {
  description = "The name of the Private DNS zone."
  default     = null
}

## redis storage container
variable "rc_redis_storage_container_name" {
  description = "The name of the azure storage container."
  type        = string
  default     = null
}

variable "rc_container_access_type" {
  description = "The Access Level configured for this Container. Possible values are blob, container or private. Defaults to private."
  type        = string
  default     = "private"
}

## virtual network
variable "sql_vnet_subnet_name" {
  description = "The name of the subnet for SQL."
  type        = string
}

variable "nw_virtual_network_name" {
  description = "The name of the Virtual Network."
  type        = string
}

variable "tags" {
  description = "A map of tags to add to all resources."
  type        = map(string)
  default     = {}
}
