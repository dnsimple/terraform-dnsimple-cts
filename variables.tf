variable "services" {
  description = "Consul services monitored by Consul NIA"
  type = map(
    object({
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
  )
}

variable "dnsimple_token" {
  description = "The API token used by DNSimple provider"
  type        = string
}

variable "dnsimple_account" {
  description = "The DNSimple account ID"
  type        = string
}

variable "dnsimple_sandbox" {
  description = "If true, use the sandbox API endpoint"
  type        = bool
}
