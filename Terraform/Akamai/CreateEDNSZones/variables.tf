variable "edgerc_path" {
  type        = string
  description = "Path to your .edgerc file"
  default     = "~/.edgerc"
}

variable "config_section" {
  type        = string
  description = "Section name in your .edgerc for Akamai authentication"
  default     = "kabara"
}

variable "contract_id" {
  type        = string
  description = "Akamai contract ID (starts with ctr_)"
}

variable "group_id" {
  type        = string
  description = "Akamai group ID (starts with grp_)"
}
#variable "ASK" {
  #type = string
  #description = "Account Switch Key"
  #}