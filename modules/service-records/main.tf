terraform {
  experiments = [module_variable_optional_attrs]

  required_providers {
    dnsimple = {
      source  = "dnsimple/dnsimple"
      version = ">= 1.0"
    }

    util = {
      source  = "poseidon/util"
      version = "0.2.2"
    }
  }
}

locals {
  zone_records_with_defaults = [
    for record in var.zone_records :
    {
      "zone_name"       = record["zone_name"] == null ? var.defaults["zone_name"] : record["zone_name"],
      "record_name"     = record["record_name"]
      "record_content"  = record["record_content"],
      "record_type"     = record["record_type"] == null ? var.defaults["record_type"] : record["record_type"],
      "record_ttl"      = record["record_ttl"] == null ? var.defaults["record_ttl"] : record["record_ttl"],
      "record_priority" = record["record_priority"],
    }
  ]

  zone_records = {
    for record in local.zone_records_with_defaults :
    join("", [record["record_name"], record["record_type"], record["record_content"], record["zone_name"]]) => record
  }
}

data "util_replace" "record_names" {
  for_each = local.zone_records

  content      = each.value["record_name"]
  replacements = { for match in regexall("\\$\\w+", each.value["record_name"]) : match => try(var.consul_service[replace(match, "$", "")], null) }
}

data "util_replace" "record_contents" {
  for_each = local.zone_records

  content      = each.value["record_content"]
  replacements = { for match in regexall("\\$\\w+", each.value["record_content"]) : match => try(var.consul_service[replace(match, "$", "")], null) }
}

resource "dnsimple_zone_record" "consul_service_records" {
  for_each = local.zone_records

  zone_name = each.value.zone_name

  name  = data.util_replace.record_names[each.key].replaced
  value = data.util_replace.record_contents[each.key].replaced

  type = each.value.record_type
  ttl  = each.value.record_ttl

  priority = each.value.record_priority
}
