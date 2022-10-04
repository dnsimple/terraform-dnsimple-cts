## Global Config
log_level = "DEBUG"
port      = 8558

syslog {
  enabled = false
}

buffer_period {
  enabled = true
  min     = "5s"
  max     = "20s"
}

# Consul Block
consul {
  address = "consul-server:8500"
}

# Driver "terraform" block
driver "terraform" {
  log         = true
  persist_log = false
}

# Task Block
task {
  name        = "dnsimple-task"
  description = "Create/delete/update DNS records"
  module      = "/dnsimple-consul"

  condition "services" {
    regexp = ".+"
    filter = "Service.Tags contains \"dnsimple\""
  }
  variable_files = ["/consul-terraform-sync/config/terraform.tfvars"]
}
