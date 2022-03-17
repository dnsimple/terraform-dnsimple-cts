# Contributing to DNSimple/terraform-dnsimple-dns-record-sync-nia

## Getting started

#### 1. Clone the repository

Clone the repository and move into it:

```shell
git clone git@github.com:dnsimple/terraform-dnsimple-dns-record-sync-nia.git
cd terraform-dnsimple-dns-record-sync-nia
```

#### 2. Install dependencies

1. [Consul-Terraform-Sync](https://www.consul.io/docs/nia/installation/install)
2. [Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli)
3. [Docker](https://docker.com)


## Testing

### Testing without running CTS and Consul

```shell
terraform plan --var-file="test/terraform.tfvars"
terraform apply --var-file="test/terraform.tfvars"
```

### Testing e2e with Docker Compose

```shell
docker compose up -d
docker compose ps
```

Coming soon.

## Releasing

The following instructions uses `$VERSION` as a placeholder, where `$VERSION` is a `MAJOR.MINOR.BUGFIX` release such as `1.2.0`.

1. Run the test suite and ensure all the tests pass.

1. Finalize the `## master` section in `CHANGELOG.md` assigning the version.

1. Commit and push the changes

    ```shell
    git commit -a -m "Release $VERSION"
    git push origin master
    ```

1. Wait for CI to complete.

1. Create a signed tag.

    ```shell
    git tag -a v$VERSION -s -m "Release $VERSION"
    git push origin --tags
    ```

1. CI and goreleaser will handle the rest
