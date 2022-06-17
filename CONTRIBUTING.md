# Contributing to DNSimple/terraform-dnsimple-dns-record-sync-nia

## Getting started

#### 1. Clone the repository

Clone the repository and move into it:

```shell
git clone git@github.com:dnsimple/terraform-dnsimple-cts.git
cd terraform-dnsimple-cts
```

#### 2. Install dependencies

1. [Consul-Terraform-Sync](https://www.consul.io/docs/nia/installation/install)
2. [Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli)
3. [Docker](https://docker.com)


## Testing

### Testing without running CTS and Consul

Add the required variables to test the integration.

```shell
cp test/terraform.tfvars.example test/terraform.tfvars
```

Plan:

```shell
terraform plan --var-file="test/terraform.tfvars"
```

Apply:

```shell
terraform apply --var-file="test/terraform.tfvars"
```

### Testing e2e with Docker Compose

Add the required variables to test the integration. Making sure to comment out or remove the `services` variable.

```shell
cp test/terraform.tfvars.example test/terraform.tfvars
```

NOTE: If you had previously uncommented the `services` variable make sure to remove the variable or comment the variable out else the integration would not work, as CTS produces `.tfvars` file with the same variable when it receives an update from the consul server.

Startup the datacenter:

```shell
docker compose up -d
docker compose ps
```

Follow the logs:

```shell
docker compose logs -f
```

In a separate terminal run helper script to register/deregester services. But first ensure to update the `Meta.zone_name` attribute of the service config in `test/api-service.json` and `test/web-service.json`.

```sh
./test/servicesctl.sh <service_name> <action>

service_name - default: web, options: [web, api]
action       - default: register, options: [register, deregester]
```

**Registerting a service:**

```shell
./test/servicesctl.sh api register
```

**Deregisterting a service:**

```shell
./test/servicesctl.sh api deregister
```

NOTES:

* The CTS container is stateless, which means that after shutting it down the tfstate will be lost.
* You can add more services by creating a config with the following convention `test/<service_name>-service.json`, and then you can use the helper the same way with the new service.


## Releasing

The following instructions uses `$VERSION` as a placeholder, where `$VERSION` is a `MAJOR.MINOR.BUGFIX` release such as `1.2.0`.

1. Run the test suite and ensure all the tests pass.

1. Finalize the `## main` section in `CHANGELOG.md` assigning the version.

1. Commit and push the changes

    ```shell
    git commit -a -m "Release $VERSION"
    git push origin main
    ```

1. Wait for CI to complete.

1. Create a signed tag.

    ```shell
    git tag -a v$VERSION -s -m "Release $VERSION"
    git push origin --tags
    ```

