variable "zone_records" {
  type = list(object({
    zone_name      = optional(string)
    record_name    = string
    record_content = string
    record_type    = optional(string)
    record_ttl     = optional(number)
  }))
}

variable "consul_service" {
  type = object({
    id        = string
    name      = string
    address   = string
    port      = number
    meta      = map(string)
    tags      = list(string)
    namespace = string
    status    = string

    node                  = string
    node_id               = string
    node_address          = string
    node_datacenter       = string
    node_tagged_addresses = map(string)
    node_meta             = map(string)
  })

}

variable "defaults" {
  type = object({
    zone_name   = optional(string)
    record_type = optional(string)
    record_ttl  = optional(number)
  })
  default = {
    record_ttl  = 3600
    record_type = "A"
  }
}
