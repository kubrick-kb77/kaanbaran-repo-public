/**
 * # Onboarding: Akamai Property
 *
 * ## Authentication
 *
 * Please refer to [DevOps Harmony / Setting up OpenAPI/EdgeGrid for PS](https://collaborate.akamai.com/confluence/pages/viewpage.action?pageId=748278616)
 * 
 * ## Usage
 * 
 * 1. Clone the repository, using following command:
 * 
 * ```bash
 * > git clone <git url>
 * > cd ps_terraform_templates/new-property/
 * ```
 * 
 * 2. Rename file `terraform.tfvars.dist` into `terraform.tfvars` (without .dist in the end) and specify required variables there.
 * 3. `terraform init` to download required providers and modules.
 * 4. `terraform plan` to see the infrastructure plan
 * 5. `terraform apply` to apply the Terraform configuration and create required infrastructure.
 *
 * Note: Run `terraform destroy` when you don't need these resources.
 *
 */

module "property" {
  source = "../modules/new-property"

  contract_id = var.contract_id
  group_id    = var.group_id

  name       = var.name
  product_id = var.product_id

  cpcode_name = var.cpcode_name

  version_notes  = var.version_notes
  hostnames      = var.hostnames
  enhanced_tls   = var.enhanced_tls
  default_origin = var.default_origin
  rule_format    = var.rule_format

  secure_by_default = var.secure_by_default
  certificate_id    = var.certificate_id
  ehn_domain        = var.ehn_domain
  ip_behavior       = var.ip_behavior

  sure_route_test_object = var.sure_route_test_object
  td_region              = var.td_region
  #ssmap_name        = var.ssmap_name
  #ssmap_srmap       = var.ssmap_srmap

  second_hostname     =  var.second_hostname
  second_origin       =  var.second_origin

  email                  = var.email
  activate_to_production = var.activate_to_production
  activate_to_staging    = var.activate_to_staging
  compliance_record      = var.compliance_record
  activation_notes       = var.activation_notes

  zone_name = var.zone_name
  dv_records = null

  providers = {
    akamai = akamai
  }
}