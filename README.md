# DNSimple Consul-Terraform-Sync NIA module

<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/0/04/Terraform_Logo.svg/512px-Terraform_Logo.svg.png" width="300px">


## Requirements

- [Terraform](https://www.terraform.io/downloads.html)
- [Consul](https://www.consul.io/docs/install)
- [Consul-Terraform-Sync](https://www.consul.io/docs/nia/installation/install)
- [DNSimple Provider](https://www.terraform.io/docs/providers/dnsimple/index.html)

## Using the sync task

Define the task in your HCL config file like so:

```hcl
# Task Block
task {
  name        = "dnsimple-task"
  description = "Create/delete/update DNS records"
  module      = "REPLACE WITH OUR MODULE URL"

  condition "services" {
    names = ["web", "api"]
  }
  variable_files = ["/terraform.tfvars"]
}
```

For a complete example of what a HCL config file might look like refer to [test/cts-config.hcl](test/cts-config.hcl)

Ensure the services that you have specified have the following parameters added in their `meta` section:

* `meta.zone_name`:`string` - The zone (domain name) that is managed through DNSimple. e.g. `vegan.pizza`
* `meta.record_name`:`string` - A valid label to create an A record in the specified zone. e.g. `api` which will result in `api.vegan.pizza`
* `meta.record_ttl`:`string` - (Optional) Valid TTL value which will be used for the A record. e.g. `600` - 10 minutes

For an exmaple please refer to [test/web-service.json](test/web-service.json). And [DNSimple Provider](https://www.terraform.io/docs/providers/dnsimple/index.html).

## Developing the Provider

Please refer to [CONTRIBUTING.md](CONTRIBUTING.md).
