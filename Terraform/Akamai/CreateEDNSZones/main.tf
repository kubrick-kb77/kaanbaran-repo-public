terraform {
  required_providers {
    akamai = {
      source  = "akamai/akamai"
      version = ">= 6.0"
    }
  }
}

provider "akamai" {
  edgerc         = var.edgerc_path
  config_section = var.config_section
}

locals {
  # Read CSV files
  zones = fileset("${path.module}/zones", "*.csv")

  zone_records = {
    for zone in local.zones :
    trimsuffix(zone, ".csv") => csvdecode(
      join("\n", [
        "name,type,ttl,target",
        chomp(file("${path.module}/zones/${zone}"))
      ])
    )
  }

  # Flatten all records
  flat_records = flatten([
    for zone, records in local.zone_records : [
      for r in records : merge(r, { zone = zone })
    ]
  ])

  # Map for for_each
  flat_records_map = zipmap(
    [for i, r in local.flat_records : i],
    local.flat_records
  )

  # Preprocess TXT targets: split by '|' and trim whitespace
processed_records = {
  for k, r in local.flat_records_map : k => merge(
    r,
    {
   target_list = (
  lower(r.type) == "txt"
  ? [for chunk in split("|", r.target) : trim(chunk, " \t\n\r")]
  : [r.target]
)
    }
  )
}
}

# Create DNS zones
resource "akamai_dns_zone" "zones" {
  for_each = local.zone_records

  contract       = var.contract_id
  group          = var.group_id
  zone           = each.key
  type           = "PRIMARY"
  comment        = "Managed by Terraform"
  sign_and_serve = false
}

# Create DNS records
resource "akamai_dns_record" "records" {
  for_each = local.processed_records

  zone       = each.value.zone
  name       = each.value.name == "@" ? each.value.zone : "${each.value.name}.${each.value.zone}"
  recordtype = each.value.type
  ttl        = each.value.ttl
  target     = each.value.target_list

  depends_on = [akamai_dns_zone.zones]
}