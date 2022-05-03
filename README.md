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
  module      = "dnsimple/cts/dnsimple"

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

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_dnsimple"></a> [dnsimple](#requirement\_dnsimple) | >= 0.11.x |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_dnsimple"></a> [dnsimple](#provider\_dnsimple) | >= 0.11.x |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [dnsimple_zone_record.records_a](https://registry.terraform.io/providers/dnsimple/dnsimple/latest/docs/resources/zone_record) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_dnsimple_account"></a> [dnsimple\_account](#input\_dnsimple\_account) | The DNSimple account ID | `string` | n/a | yes |
| <a name="input_dnsimple_sandbox"></a> [dnsimple\_sandbox](#input\_dnsimple\_sandbox) | If true, use the sandbox API endpoint | `bool` | n/a | yes |
| <a name="input_dnsimple_token"></a> [dnsimple\_token](#input\_dnsimple\_token) | The API token used by DNSimple provider | `string` | n/a | yes |
| <a name="input_services"></a> [services](#input\_services) | Consul services monitored by Consul NIA | <pre>map(<br>    object({<br>      id        = string<br>      name      = string<br>      address   = string<br>      port      = number<br>      meta      = map(string)<br>      tags      = list(string)<br>      namespace = string<br>      status    = string<br><br>      node                  = string<br>      node_id               = string<br>      node_address          = string<br>      node_datacenter       = string<br>      node_tagged_addresses = map(string)<br>      node_meta             = map(string)<br>    })<br>  )</pre> | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_service_map"></a> [service\_map](#output\_service\_map) | n/a |
<!-- END_TF_DOCS -->