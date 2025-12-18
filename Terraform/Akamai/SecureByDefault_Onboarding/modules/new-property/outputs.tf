output "property_id" {
  value       = akamai_property.this.id
  description = "The property's unique identifier."
}

output "rules_errors" {
  value       = akamai_property.this.rule_errors
  description = "The contents of errors field returned by the API."
}

output "cpcode_id" {
  value       = tonumber(trimprefix(akamai_cp_code.this.id, "cpc_"))
  description = "The CP Code's unique identifier."
}

output "zones" {
  value = local.zones
}