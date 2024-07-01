terraform {
  required_providers {
    dnsimple = {
      source  = "dnsimple/dnsimple"
      version = ">= 1.0"
    }

    util = {
      source  = "poseidon/util"
      version = "0.3.0"
    }
  }
}

provider "dnsimple" {
  token      = var.dnsimple_token
  account    = var.dnsimple_account
  sandbox    = var.dnsimple_sandbox
  user_agent = "DNSimple-Consul-Terraform"
}

module "service_records" {
  source = "./modules/service-records"

  for_each = local.consul_services

  consul_service = each.value.service
  defaults       = each.value.defaults

  zone_records = each.value.zone_records
}

locals {
  consul_services = {
    for id, service in var.services :
    id => {
      "name" = service.name,
      "defaults" = {
        "zone_name"   = lookup(service.meta, "dnsimple_default_zone", null),
        "record_type" = lookup(service.meta, "dnsimple_default_record_type", "A"),
        "record_ttl"  = lookup(service.meta, "dnsimple_default_record_ttl", 3600),
      },
      "zone_records" = concat([{
        "zone_name"       = lookup(service.meta, "dnsimple_zone_name", null),
        "record_name"     = lookup(service.meta, "dnsimple_record_name", null),
        "record_content"  = lookup(service.meta, "dnsimple_record_content", null),
        "record_type"     = lookup(service.meta, "dnsimple_record_type", null),
        "record_ttl"      = lookup(service.meta, "dnsimple_record_ttl", null),
        "record_priority" = lookup(service.meta, "dnsimple_record_priority", null),
        }], [
        for n in range(0, 60) :
        {
          "zone_name"       = lookup(service.meta, "dnsimple_zone_name-${n}", null),
          "record_name"     = lookup(service.meta, "dnsimple_record_name-${n}", null),
          "record_content"  = lookup(service.meta, "dnsimple_record_content-${n}", null),
          "record_type"     = lookup(service.meta, "dnsimple_record_type-${n}", null),
          "record_ttl"      = lookup(service.meta, "dnsimple_record_ttl-${n}", null),
          "record_priority" = lookup(service.meta, "dnsimple_record_priority-${n}", null),
        } if lookup(service.meta, "dnsimple_record_content-${n}", null) != null
      ])

      "service" = service,
    }
  }
}
