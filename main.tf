terraform {
  required_providers {
    dnsimple = {
      source  = "dnsimple/dnsimple"
      version = ">= 0.12"
    }
  }
}

provider "dnsimple" {
  token      = var.dnsimple_token
  account    = var.dnsimple_account
  sandbox    = var.dnsimple_sandbox
  user_agent = "DNSimple-Consul-Terraform"
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
    for id, service in var.services :
    id => {
      "name"        = service.name,
      "address"     = service.address,
      "zone_name"   = service.meta["zone_name"],
      "record_name" = service.meta["record_name"],
      "record_ttl"  = lookup(service.meta, "record_ttl", 3600),
    }
  }
}
