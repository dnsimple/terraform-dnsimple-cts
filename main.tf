terraform {
  required_providers {
    dnsimple = {
      source  = "dnsimple/dnsimple"
      version = ">= 0.11.1"
    }
  }
}

provider "dnsimple" {
  token   = var.dnsimple_token
  account = var.dnsimple_account
  sandbox = var.dnsimple_sandbox
}

# Add a record to a service specific domain
resource "dnsimple_zone_record" "records_a" {
  for_each = local.consul_services

  zone_name = each.value.zone_name
  name      = each.value.record_name
  value     = each.value.address
  type      = "A"
  ttl       = each.value.record_ttl
}

locals {
  consul_services = {
    for id, s in var.services :
    id => {
      "name"        = s.name,
      "address"     = s.address,
      "zone_name"   = s.meta["zone_name"],
      "record_name" = s.meta["record_name"],
      "record_ttl"  = lookup(s.meta, "record_ttl", 3600),
    }
  }
}
