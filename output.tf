output "service_map" {
  value = [for id, s in local.consul_services :
    "${id}:${s.record_name}.${s.zone_name}:A:${s.record_ttl}:${s.address}"
  ]
}
