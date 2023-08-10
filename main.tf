terraform {
  required_providers {
    dnsimple = {
      source  = "dnsimple/dnsimple"
      version = ">= 1.0"
    }
  }
}

provider "dnsimple" {
  token      = var.dnsimple_token
  account    = var.dnsimple_account
  sandbox    = var.dnsimple_sandbox
  user_agent = "DNSimple-Consul-Terraform"
}

# Add a record of any type to a service specific domain
resource "dnsimple_zone_record" "consul_service_records" {
  for_each = local.consul_services

  zone_name = each.value.zone_name
  name      = each.value.record_name
  value     = each.value.record_content
  type      = each.value.record_type
  ttl       = each.value.record_ttl
}

locals {
  consul_services = {
    for id, service in var.services :
    id => {
      "name"           = service.name,
      "zone_name"      = service.meta["zone_name"],
      "record_name"    = service.meta["record_name"],
      "record_content" = lookup(service.meta, "record_content", service.address),
      "record_type"    = lookup(service.meta, "record_type", "A"),
      "record_ttl"     = lookup(service.meta, "record_ttl", 3600),
    }
  }
}
