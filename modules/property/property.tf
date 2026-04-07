terraform {
  required_providers {
    akamai = {
      source  = "akamai/akamai"
      version = ">= 10.0.0"
    }
  }
  required_version = ">= 1.0"
}
module "rules" {
  source                         = "./rules"
  rule_variables                 = var.rule_variables
  rule_default_origin_hostname   = var.rule_default_origin_hostname
  rule_traffic_reporting_cp_code = var.rule_traffic_reporting_cp_code
}

resource "akamai_edge_hostname" "edge_hostnames" {
  for_each = var.edge_hostnames

  contract_id   = var.contract_id
  group_id      = var.group_id
  ip_behavior   = each.value.ip_behavior
  edge_hostname = each.value.edge_hostname
  certificate   = try(each.value.certificate, null)
  ttl           = try(each.value.ttl, null)
  
  lifecycle {
    ignore_changes = [ 
      certificate
    ]
  }
}

resource "akamai_property" "ion_standard" {
  name        = var.property_config.name
  contract_id = var.contract_id
  group_id    = var.group_id
  product_id  = var.property_config.product_id

  dynamic "hostnames" {
    for_each = var.property_hostnames
    content {
      cname_from             = hostnames.value.cname_from
      cname_to               = hostnames.value.cname_to
      cert_provisioning_type = hostnames.value.cert_provisioning_type

      dynamic "ccm_certificates" {
        for_each = hostnames.value.ccm_certificates == null ? [] : [hostnames.value.ccm_certificates]
        content {
          rsa_cert_id   = try(ccm_certificates.value.rsa_cert_id, null)
          ecdsa_cert_id = try(ccm_certificates.value.ecdsa_cert_id, null)
        }
      }

      dynamic "mtls" {
        for_each = hostnames.value.mtls == null ? [] : [hostnames.value.mtls]
        content {
          ca_set_id          = mtls.value.ca_set_id
          check_client_ocsp  = mtls.value.check_client_ocsp
          send_ca_set_client = mtls.value.send_ca_set_client
        }
      }

      dynamic "tls_configuration" {
        for_each = hostnames.value.tls_configuration == null ? [] : [hostnames.value.tls_configuration]
        content {
          cipher_profile              = tls_configuration.value.cipher_profile
          disallowed_tls_versions     = try(tls_configuration.value.disallowed_tls_versions, null)
          fips_mode                   = tls_configuration.value.fips_mode
          staple_server_ocsp_response = tls_configuration.value.staple_server_ocsp_response
        }
      }
    }
  }
  rule_format   = module.rules.rule_format
  rules         = module.rules.rules
  version_notes = var.version_notes
}

resource "akamai_property_activation" "ion-standard-activation-staging" {
  property_id                    = akamai_property.ion_standard.id
  contact                        = var.activation_config.staging.contacts
  version                        = var.activate_latest_on_staging ? akamai_property.ion_standard.latest_version : akamai_property.ion_standard.staging_version
  network                        = "STAGING"
  note                           = var.version_notes
  auto_acknowledge_rule_warnings = true

  lifecycle {
    ignore_changes = [
      note
    ]
  }
}

resource "akamai_property_activation" "ion-standard-activation-production" {
  property_id                    = akamai_property.ion_standard.id
  contact                        = var.activation_config.production.contacts
  version                        = var.activate_latest_on_production ? akamai_property.ion_standard.latest_version : akamai_property.ion_standard.production_version
  network                        = "PRODUCTION"
  note                           = var.version_notes
  auto_acknowledge_rule_warnings = true

  lifecycle {
    ignore_changes = [
      note
    ]
  }
}