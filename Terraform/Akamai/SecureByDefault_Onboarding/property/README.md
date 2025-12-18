<!-- BEGIN_TF_DOCS -->
# Onboarding: Akamai Property

## Authentication

Please refer to (https://techdocs.akamai.com/developer/docs/edgegrid)

## Usage

1. Clone the repository, using following command:

```bash
> git clone <git url>
> cd ps_terraform_templates/new-property/
```

2. Rename file `terraform.tfvars.dist` into `terraform.tfvars` (without .dist in the end) and specify required variables there.
3. `terraform init` to download required providers and modules.
4. `terraform plan` to see the infrastructure plan
5. `terraform apply` to apply the Terraform configuration and create required infrastructure.

Note: Run `terraform destroy` when you don't need these resources.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0,<2.0.0 |
| <a name="requirement_akamai"></a> [akamai](#requirement\_akamai) | >= 3.6.0, < 4.0.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_property"></a> [property](#module\_property) | ../modules/new-property | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_activate_to_production"></a> [activate\_to\_production](#input\_activate\_to\_production) | n/a | `bool` | `false` | no |
| <a name="input_activate_to_staging"></a> [activate\_to\_staging](#input\_activate\_to\_staging) | n/a | `bool` | `false` | no |
| <a name="input_activation_notes"></a> [activation\_notes](#input\_activation\_notes) | Activation notes. Leave default value until DXE-2373 is resolved, unless you know what you are doing. | `string` | `"activated with terraform"` | no |
| <a name="input_certificate_id"></a> [certificate\_id](#input\_certificate\_id) | Certificate enrollment id. Only applicable if enhanced\_tls is true, and secure\_by\_default<br>    is false.<br><br>    Can be retrieved using AkamaiPowershell or the Akamai CPS CLI. | `number` | `null` | no |
| <a name="input_compliance_record"></a> [compliance\_record](#input\_compliance\_record) | Set this according to the change management policy if activate\_to\_production is true.<br><br>Refer to https://collaborate.akamai.com/confluence/pages/viewpage.action?spaceKey=DEVOPSHARMONY&title=Terraform+for+Akamai+PS<br>for further guidance. | <pre>object({<br>    noncompliance_reason = string<br>    peer_reviewed_by     = optional(string)<br>    customer_email       = optional(string)<br>    unit_tested          = optional(bool)<br>  })</pre> | `null` | no |
| <a name="input_contract_id"></a> [contract\_id](#input\_contract\_id) | Contract ID for property/config creation | `string` | n/a | yes |
| <a name="input_cpcode_name"></a> [cpcode\_name](#input\_cpcode\_name) | Default CP Code name. Will be the property name (var.name) if null. | `string` | `null` | no |
| <a name="input_default_origin"></a> [default\_origin](#input\_default\_origin) | Default origin server for all properties | `string` | n/a | yes |
| <a name="input_edgerc_path"></a> [edgerc\_path](#input\_edgerc\_path) | Path to the .edgerc file. | `string` | `null` | no |
| <a name="input_edgerc_section"></a> [edgerc\_section](#input\_edgerc\_section) | Section in the .edgerc file.<br><br>    For professional services, it is recommended to create a new section for<br>    each account managed. | `string` | n/a | yes |
| <a name="input_ehn_domain"></a> [ehn\_domain](#input\_ehn\_domain) | EdgeHostname domain, e.g. edgesuite.net or edgekey.net. Will default to one or<br>    the other, based on the value of enhanced\_tls. | `string` | `null` | no |
| <a name="input_email"></a> [email](#input\_email) | Email address used for activations. | `string` | n/a | yes |
| <a name="input_enhanced_tls"></a> [enhanced\_tls](#input\_enhanced\_tls) | Boolean to switch between Enhanced and Standard TLS modes | `bool` | n/a | yes |
| <a name="input_group_id"></a> [group\_id](#input\_group\_id) | Group ID for property/config creation. | `string` | n/a | yes |
| <a name="input_hostnames"></a> [hostnames](#input\_hostnames) | List of hostnames. | `list(string)` | n/a | yes |
| <a name="input_ip_behavior"></a> [ip\_behavior](#input\_ip\_behavior) | EdgeHostname IP behaviour. | `string` | `"IPV6_COMPLIANCE"` | no |
| <a name="input_name"></a> [name](#input\_name) | Property name. | `string` | n/a | yes |
| <a name="input_product_id"></a> [product\_id](#input\_product\_id) | Property Manager product - Default will be Ion. | `string` | `"Fresca"` | no |
| <a name="input_rule_format"></a> [rule\_format](#input\_rule\_format) | Property rule format | `string` | `"latest"` | no |
| <a name="input_secure_by_default"></a> [secure\_by\_default](#input\_secure\_by\_default) | Secure by default. Set to true to use the DEFAULT certificate provisioning type.<br><br>    This is the easiest for automation, because Akamai takes care of provisioning the certificate<br>    using a Let's Encrypt DV SAN in a fully managed way.<br><br>    If the customer requires an OV SAN, or Secure by Default is inapplicable for whatever<br>    other reason, set this to false. | `bool` | `true` | no |
| <a name="input_sure_route_test_object"></a> [sure\_route\_test\_object](#input\_sure\_route\_test\_object) | Test object path for SureRoute | `string` | `"/akamai/testobject.html"` | no |
| <a name="input_td_region"></a> [td\_region](#input\_td\_region) | Region (map) for Tiered Distribution behaviour. Only applies if network is Standard TLS.<br>    Options are: CH2, CHAPAC, CHEU2, CHEUS2, CHWUS2, CHCUS2, CHAUS | `string` | `"CH2"` | no |
| <a name="input_version_notes"></a> [version\_notes](#input\_version\_notes) | Property version notes. | `string` | `""` | no |

## Outputs

No outputs.

# Contributing

When contributing to this repository, please first discuss the change you wish to make via issue,
email, or any other method with the owners of this repository before making a change.

## Prerequisites

Please ensure you have the following installed before you start, to ensure that your contribution
follows the same quality standards.

* [`terraform`](https://developer.hashicorp.com/terraform/downloads?product_intent=terraform)
* [`terraform-docs`](https://terraform-docs.io/)
* [`tflint`](https://github.com/terraform-linters/tflint)
* [`tfsec`](https://github.com/aquasecurity/tfsec)
* [`pre-commit`](https://pre-commit.com/)

Finally, install `pre-commit` into your working copy:

```
pre-commit install
```

This will ensure that hooks run before you commit.

## Pull Request Process

1. Fork the project.
2. Start a feature branch based on the `main` branch (`git checkout -b <feature-name> main`).
3. Update the README.md with details of changes including example hcl blocks and [example files](./examples) if appropriate.
4. Commit and push your changes.
5. Issue a pull request and wait for your code to be reviewed.

## Checklists for contributions

- [ ] Add [semantics prefix](#semantic-pull-requests) to your PR or Commits (at least one of your commit groups)
- [ ] README.md has been updated.

## Semantic Pull Requests

To generate changelog, Pull Requests or Commits must have semantic and must follow conventional specs below:

- `feat:` for new features
- `fix:` for bug fixes
- `improvement:` for enhancements
- `docs:` for documentation and examples
- `refactor:` for code refactoring
- `test:` for tests
- `ci:` for CI purpose
- `chore:` for chores stuff

The `chore` prefix skipped during changelog generation. It can be used for `chore: update changelog` commit message by example.
<!-- END_TF_DOCS -->