# -------------------------------------------------
# Common variables
# -------------------------------------------------

variable "contract_id" {
  type = string
}

variable "group_id" {
  type = string
}

# -------------------------------------------------
# Property variables
# -------------------------------------------------

variable "property_config" {
  type = object({
    name       = string
    product_id = string
  })
}

variable "edge_hostnames" {
  type = map(object({
    ip_behavior   = string
    edge_hostname = string
    certificate   = optional(number)
    ttl           = optional(number)
  }))
}

variable "property_hostnames" {
  type = map(object({
    cname_from             = string
    cname_to               = string
    cert_provisioning_type = string
    ccm_certificates = optional(object({
      rsa_cert_id   = optional(string)
      ecdsa_cert_id = optional(string)
    }))
    mtls = optional(object({
      ca_set_id          = string
      check_client_ocsp  = bool
      send_ca_set_client = bool
    }))
    tls_configuration = optional(object({
      cipher_profile              = string
      disallowed_tls_versions     = optional(list(string))
      fips_mode                   = bool
      staple_server_ocsp_response = bool
    }))
  }))
}

variable "rule_variables" {
  type = map(object({
    name        = string
    description = string
    value       = string
    hidden      = bool
    sensitive   = bool
  }))
}
variable "rule_default_origin_hostname" {
  type = string
}
variable "rule_traffic_reporting_cp_code" {
  type = number
}

variable "activation_config" {
  type = object({
    staging = object({
      contacts = list(string)
    })
    production = object({
      contacts = list(string)
    })
  })
}

variable "version_notes" {
  type    = string
  default = ""
}

variable "activate_latest_on_staging" {
  type    = bool
  default = false
}

variable "activate_latest_on_production" {
  type    = bool
  default = false
}

variable "import_property_id" {
  type = string
  default = ""
}