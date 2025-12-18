## ----------------------------------------------------------------------------
## EdgeGrid
## ----------------------------------------------------------------------------

variable "edgerc_path" {
  description = <<EOD
    Path to the .edgerc file.
  EOD
  type        = string
  default     = null
}

variable "edgerc_section" {
  description = <<EOD
    Section in the .edgerc file.

    For professional services, it is recommended to create a new section for
    each account managed.
  EOD
  type        = string
}

## ----------------------------------------------------------------------------
## Scope
## ----------------------------------------------------------------------------

variable "contract_id" {
  description = "Contract ID for property/config creation"
  type        = string
}

variable "group_id" {
  description = "Group ID for property/config creation."
  type        = string
}

## ----------------------------------------------------------------------------
## Property
## ----------------------------------------------------------------------------

variable "product_id" {
  description = "Property Manager product - Default will be Ion."
  type        = string
  default     = "Site_Accel"
}

variable "name" {
  description = "Property name."
  type        = string
}

variable "version_notes" {
  description = "Property version notes."
  type        = string
  default     = "Initial Config"
}

variable "hostnames" {
  description = "List of hostnames."
  type        = list(string)
}

variable "enhanced_tls" {
  type        = bool
  description = "Boolean to switch between Enhanced and Standard TLS modes"
}

variable "default_origin" {
  type        = string
  description = "Default origin server for all properties"
}

variable "rule_format" {
  type        = string
  description = "Property rule format"
  default     = "latest"
}

variable "sure_route_test_object" {
  type        = string
  description = "Test object path for SureRoute"
  default     = "/akamai/testobject.html"
}

variable "td_region" {
  type        = string
  description = <<EOD
    Region (map) for Tiered Distribution behaviour. Only applies if network is Standard TLS.
    Options are: CH2, CHAPAC, CHEU2, CHEUS2, CHWUS2, CHCUS2, CHAUS
  EOD
  default     = "CH2"
}

/*variable "ssmap_name" {
  type        = string
  description = "SiteShield map name"
}

variable "ssmap_srmap" {
  type        = string
  description = "SiteShield SR map"
}

variable "ssmap_value" {
  type        = string
  description = "SiteShield value"
} */

variable "second_hostname" {
  type        = string
  description = "Second Hostname"
}

variable "second_origin" {
  type        = string
  description = "Second Origin"
}

## ----------------------------------------------------------------------------
## Activation
## ----------------------------------------------------------------------------

variable "email" {
  type        = string
  description = "Email address used for activations."
}

variable "activate_to_staging" {
  type    = bool
  default = false
}

variable "activate_to_production" {
  type    = bool
  default = false
}

variable "compliance_record" {
  description = <<-EOD
    Set this according to the change management policy if activate_to_production is true.

    Refer to https://collaborate.akamai.com/confluence/pages/viewpage.action?spaceKey=DEVOPSHARMONY&title=Terraform+for+Akamai+PS
    for further guidance.
  EOD
  type = object({
    noncompliance_reason = string
    peer_reviewed_by     = optional(string)
    customer_email       = optional(string)
    unit_tested          = optional(bool)
  })
  default = null
}

variable "activation_notes" {
  description = "Activation notes. Leave default value until DXE-2373 is resolved, unless you know what you are doing."
  type        = string
  default     = "activated with terraform"
}

## ----------------------------------------------------------------------------
## CP Code
## ----------------------------------------------------------------------------

variable "cpcode_name" {
  description = "Default CP Code name. Will be the property name (var.name) if null."
  type        = string
  default     = null
}

## ----------------------------------------------------------------------------
## Certificate
## ----------------------------------------------------------------------------

variable "secure_by_default" {
  description = <<EOD
    Secure by default. Set to true to use the DEFAULT certificate provisioning type.

    This is the easiest for automation, because Akamai takes care of provisioning the certificate
    using a Let's Encrypt DV SAN in a fully managed way.

    If the customer requires an OV SAN, or Secure by Default is inapplicable for whatever
    other reason, set this to false.
  EOD
  type        = bool
  default     = true
}

variable "certificate_id" {
  description = <<EOD
    Certificate enrollment id. Only applicable if enhanced_tls is true, and secure_by_default
    is false.

    Can be retrieved using AkamaiPowershell or the Akamai CPS CLI.
  EOD
  type        = number
  default     = null
}

## ----------------------------------------------------------------------------
## EdgeHostname
## ----------------------------------------------------------------------------

variable "ehn_domain" {
  description = <<EOD
    EdgeHostname domain, e.g. edgesuite.net or edgekey.net. Will default to one or
    the other, based on the value of enhanced_tls.
  EOD
  type        = string
  default     = null
}

variable "ip_behavior" {
  description = <<EOD
    EdgeHostname IP behaviour.
  EOD
  type        = string
  default     = "IPV6_COMPLIANCE"

  validation {
    condition     = length(regexall("^(IPV4|IPV6_COMPLIANCE|IPV6_PERFORMANCE)$", var.ip_behavior)) > 0
    error_message = "ERROR: Valid types are IPV4, IPV6_COMPLIANCE or IPV6_PERFORMANCE."
  }
}

## ----------------------------------------------------------------------------
## Zones
## ----------------------------------------------------------------------------

variable "zone_name" {
  description = "eDNS zone name"
  type        = string
  default     = null
}