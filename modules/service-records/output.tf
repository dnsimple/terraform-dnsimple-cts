output "defaults" {
  value = var.defaults
}

output "service_record_map" {
  value = [
    for record in dnsimple_zone_record.consul_service_records :
    "${record.zone_name}:${record.name}:${record.type}:${record.ttl}:${record.value}"
  ]
}
