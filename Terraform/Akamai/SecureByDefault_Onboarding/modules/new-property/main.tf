/**
 * # Onboarding: new-property
 *
 * The use case for this module is to quickly create a new configuration
 * serving a set of hostnames.
 *
 * Read on to find out which resources are provisioned as part of this
 * process, and how to customize!
 */



locals {
  ehn_domain = coalesce(
    var.ehn_domain,
    (var.enhanced_tls == true) ? "edgekey.net" : "edgesuite.net"
  )

  etls_hostnames = (var.enhanced_tls && var.secure_by_default == false) ? var.hostnames : []

  stls_hostnames = (var.enhanced_tls && var.secure_by_default) ? [] : var.hostnames

  ehn_certificate = (var.enhanced_tls == true && var.secure_by_default == false) ? var.certificate_id : null

  zones = var.zone_name != null ? [var.zone_name] : compact(distinct([for domain in var.hostnames : regex("([^.]+\\.[^.]+)$", domain)[0]]))

  dv_records = { for entry in resource.akamai_property.this.hostnames[*].cert_status[0] : entry.hostname => entry }

}

data "akamai_property_rules_template" "this" {
  template_file = abspath("${path.module}/property-snippets/main.json")
  variables {
    name  = "default_origin"
    value = var.default_origin
    type  = "string"
  }
  variables {
    name  = "default_cpcode"
    value = tonumber(trimprefix(akamai_cp_code.this.id, "cpc_"))
    type  = "number"
  }
  variables {
    name  = "sure_route_test_object"
    value = var.sure_route_test_object
    type  = "string"
  }
  variables {
    name  = "td_region"
    value = var.td_region
    type  = "string"
  }
  /*variables {
    name = "ssmap_name"
    value = var.ssmap_name
    type = "string"
  }
  variables {
    name = "ssmap_srmap"
    value = var.ssmap_srmap
    type = "string"
  }
  variables {
    name = "ssmap_value"
    value = var.ssmap_value
    type = "string"
  } */

  variables {
    name  = "second_origin"
    value = var.second_origin
    type  = "string"
  }
  variables {
    name  = "second_hostname"
    value = var.second_hostname
    type  = "string"
  }
}

resource "akamai_cp_code" "this" {
  name        = replace(coalesce(var.cpcode_name, var.name), "/[^a-zA-Z0-9-.]/", "-")
  contract_id = var.contract_id
  group_id    = var.group_id
  product_id  = var.product_id
}

resource "akamai_edge_hostname" "stls" {
  for_each      = toset(local.stls_hostnames)
  product_id    = var.product_id
  contract_id   = var.contract_id
  group_id      = var.group_id
  edge_hostname = "${each.key}.${local.ehn_domain}"
  ip_behavior   = var.ip_behavior
} 

resource "akamai_edge_hostname" "etls" {
  for_each      = toset(local.etls_hostnames)
  product_id    = var.product_id
  contract_id   = var.contract_id
  group_id      = var.group_id
  edge_hostname = "${each.key}.${local.ehn_domain}"
  certificate   = local.ehn_certificate
  ip_behavior   = var.ip_behavior
}

/*resource "akamai_dns_zone" "this" {
  for_each        = toset(local.zones)
  zone            = each.value
  contract        = var.contract_id
  type            = "primary"
  comment         = var.activation_notes
  group           = var.group_id
  sign_and_serve  = false
}*/

resource "akamai_property" "this" {
  name        = var.name
  product_id  = var.product_id
  contract_id = var.contract_id
  group_id    = var.group_id
  rule_format = var.rule_format

  dynamic "hostnames" {
    for_each = var.hostnames
    content {
      cname_from             = hostnames.value
      cname_to               = "${hostnames.value}.${local.ehn_domain}"
      cert_provisioning_type = var.secure_by_default ? "DEFAULT" : "CPS_MANAGED"
    }
  }

  rules = replace(
    data.akamai_property_rules_template.this.json,
    "\"rules\"", "\"comments\": \"${var.version_notes}\", \"rules\""
  )

  depends_on = [
    data.akamai_property_rules_template.this,
    akamai_edge_hostname.etls,
    akamai_edge_hostname.stls,
    #akamai_dns_zone.this
  ]
}

resource "akamai_dns_record" "sbd_challenge_cname" {
  for_each    = toset(var.hostnames)
  zone        = coalesce(var.zone_name, regex("([^.]+\\.[^.]+)$", each.key)[0])
  name        = "_acme-challenge.${each.value}"
  target      = [lookup(local.dv_records["_acme-challenge.${each.value}"], "target")]
  recordtype  = "CNAME"
  ttl         = 60

  depends_on = [
    akamai_property.this
   ]
}

resource "akamai_dns_record" "sbd_ehn_cname" {
  for_each    = toset(var.hostnames)
  zone        = coalesce(var.zone_name, regex("([^.]+\\.[^.]+)$", each.key)[0])
  name        = each.value
  target      = ["${each.value}.${local.ehn_domain}"]
  recordtype  = "CNAME"
  ttl         = 60

  depends_on = [ 
    akamai_property.this
   ]
}

resource "akamai_property_activation" "staging" {
  count       = var.activate_to_staging ? 1 : 0
  network     = "STAGING"
  property_id = akamai_property.this.id
  version     = akamai_property.this.latest_version
  note        = var.activation_notes
  contact     = [var.email]
  auto_acknowledge_rule_warnings = true
}

resource "akamai_property_activation" "production" {
  count       = var.activate_to_production ? 1 : 0
  network     = "PRODUCTION"
  property_id = akamai_property.this.id
  version     = akamai_property.this.latest_version
  note        = var.activation_notes
  contact     = [var.email]
  auto_acknowledge_rule_warnings = true
  compliance_record {
    noncompliance_reason_other {
      other_noncompliance_reason = "NO_PRODUCTION_TRAFFIC"
    }
}
}