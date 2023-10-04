# DNSimple Consul-Terraform-Sync NIA module

<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/0/04/Terraform_Logo.svg/512px-Terraform_Logo.svg.png" width="300px">

The DNSimple Consul-Terraform-Sync Network Infrastructure Automation module enables automated and dynamic management of DNSimple resources based on health and state changes in the Consul service catalog. Ensure consistent and scalable infrastructure with centralized control over DNSimple resources using the DNSimple Consul-Terraform-Sync NIA module.

This module for Consul-Terraform-Sync has been tested with [HCP Consul server](https://cloud.hashicorp.com/products/consul).

## Requirements

- [Terraform](https://www.terraform.io/downloads.html) >= 1.1.0
- [Consul](https://www.consul.io/docs/install)
- [Consul-Terraform-Sync](https://www.consul.io/docs/nia/installation/install)
- [DNSimple Provider](https://www.terraform.io/docs/providers/dnsimple/index.html)

## Using the sync task

Define the task in your HCL config file like so:

```hcl
# Task Block
task {
  name        = "dnsimple-task"
  description = "Dynamic DNS record management in DNSimple based on Consul service metadata"
  module      = "dnsimple/cts/dnsimple"

  condition "services" {
    regexp = ".+"
    filter = "Service.Kind != \"connect-proxy\" and Service.Tags contains \"dnsimple\""
  }
  variable_files = ["/terraform.tfvars"]
}
```

For a complete example of what a HCL config file might look like refer to [test/cts-config.hcl](test/cts-config.hcl)

The services that you have specified can have the following parameters added in their `meta` section:

* `meta.dnsimple_default_zone`:`string` - (Optional) The default zone (domain name) that will be used for all records where the `meta.dnsimple_zone_name` is not specified. e.g. `vegan.pizza`
* `meta.dnsimple_default_record_type`:`string` - (Optional) The default record type that will be used for all records where the `meta.dnsimple_record_type` is not specified. (Default: `A`)
* `meta.dnsimple_default_record_ttl`:`string` - (Optional) The default record TTL that will be used for all records where the `meta.dnsimple_record_ttl` is not specified. (Default: `3600`)

* `meta.dnsimple_zone_name`:`string` - (Optional) The zone (domain name) that will be used to create the record. And is only optional if the `meta.dnsimple_default_zone` is specified. e.g. `vegan.pizza`
* `meta.dnsimple_record_name`:`string` - (Required) A valid label to create an the record in the specified zone. e.g. `api` which will result in `api.vegan.pizza`
* `meta.dnsimple_record_ttl`:`string` - (Optional) Valid TTL value which will be used for the record. e.g. `600` - 10 minutes (Default: `3600` - 1 hour)
* `meta.dnsimple_record_type`:`string` - (Optional) Valid record type which will be used for the record. And is only optional if the `meta.dnsimple_default_record_type` is specified. e.g. `A` (Default: `A`)
* `meta.dnsimple_record_content`:`string` - (Optional) Valid record content which will be used for the record. e.g. `$address`, `127.0.0.1`

To create more records for a single service you can add an index (max index value is 60) to the above attributes for example:

```hcl
meta = {
  dnsimple_zone_name = "vegan.pizza"
  dnsimple_record_name = "api"
  dnsimple_record_content = "$address"
  dnsimple_record_ttl = "600"

  dnsimple_zone_name-1 = "meatlover.pizza"
  dnsimple_record_name-1 = "api-internal"
  dnsimple_record_content-1 = "$node_address"
  dnsimple_record_ttl-1 = "300"
}
```

**Attribute Expansion**

The **meta.dnsimple_record_name** and **meta.dnsimple_record_content** attributes support attribute expansion. To expand an attribute you can use the following syntax:

```
$<attribute>
```

Where the `<attribute>` is one of the following service attributes:

```hcl
id        = string
name      = string
address   = string
port      = number
namespace = string
status    = string

node                  = string
node_id               = string
node_address          = string
node_datacenter       = string
```

If you would like to see more attributes supported please raise an issue.

For more exmaples please refer to [test/web-service.json](test/web-service.json). And [DNSimple Provider](https://www.terraform.io/docs/providers/dnsimple/index.html).

NOTE: In the example above as part of the filtering we exclude all events that are part of a Consul **connect proxy** service, as those events will result in duplication of DNS records.

## Developing the Provider

Please refer to [CONTRIBUTING.md](CONTRIBUTING.md).

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name                                                                   | Version           |
| ---------------------------------------------------------------------- | ----------------- |
| Terraform                                                              | >= 1.1.0, < 1.3.0 |
| <a name="requirement_dnsimple"></a> [dnsimple](#requirement\_dnsimple) | >= 1.3.0          |

## Providers

| Name                                                             | Version  |
| ---------------------------------------------------------------- | -------- |
| <a name="provider_dnsimple"></a> [dnsimple](#provider\_dnsimple) | >= 1.3.0 |

## Modules

No modules.

## Resources

| Name                                                                                                                          | Type     |
| ----------------------------------------------------------------------------------------------------------------------------- | -------- |
| [dnsimple_zone_record.records_a](https://registry.terraform.io/providers/dnsimple/dnsimple/latest/docs/resources/zone_record) | resource |

## Inputs

| Name                                                                                 | Description                             | Type                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      | Default | Required |
| ------------------------------------------------------------------------------------ | --------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------- | :------: |
| <a name="input_dnsimple_account"></a> [dnsimple\_account](#input\_dnsimple\_account) | The DNSimple account ID                 | `string`                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  | n/a     |   yes    |
| <a name="input_dnsimple_sandbox"></a> [dnsimple\_sandbox](#input\_dnsimple\_sandbox) | If true, use the sandbox API endpoint   | `bool`                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    | n/a     |   yes    |
| <a name="input_dnsimple_token"></a> [dnsimple\_token](#input\_dnsimple\_token)       | The API token used by DNSimple provider | `string`                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  | n/a     |   yes    |
| <a name="input_services"></a> [services](#input\_services)                           | Consul services monitored by Consul NIA | <pre>map(<br>    object({<br>      id        = string<br>      name      = string<br>      address   = string<br>      port      = number<br>      meta      = map(string)<br>      tags      = list(string)<br>      namespace = string<br>      status    = string<br><br>      node                  = string<br>      node_id               = string<br>      node_address          = string<br>      node_datacenter       = string<br>      node_tagged_addresses = map(string)<br>      node_meta             = map(string)<br>    })<br>  )</pre> | n/a     |   yes    |

## Outputs

| Name                                                                                | Description |
| ----------------------------------------------------------------------------------- | ----------- |
| <a name="output_service_records"></a> [service\_records](#output\_service\_records) | n/a         |
<!-- END_TF_DOCS -->
