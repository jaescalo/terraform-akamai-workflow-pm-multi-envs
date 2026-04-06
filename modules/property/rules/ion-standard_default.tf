
data "akamai_property_rules_builder" "ion_standard_rule_default" {
  rules_v2026_01_09 {
    name      = "default"
    is_secure = false
    comments  = "The Default Rule template contains all the necessary and recommended behaviors. Rules are evaluated from top to bottom and the last matching rule wins."
    dynamic "variable" {
      for_each = var.rule_variables
      content {
        name        = variable.value.name
        description = variable.value.description
        value       = variable.value.value
        hidden      = variable.value.hidden
        sensitive   = variable.value.sensitive
      }
    }
    behavior {
      origin {
        cache_key_hostname            = "REQUEST_HOST_HEADER"
        compress                      = true
        enable_true_client_ip         = true
        forward_host_header           = "REQUEST_HOST_HEADER"
        hostname                      = var.rule_default_origin_hostname
        http_port                     = 80
        https_port                    = 443
        ip_version                    = "IPV4"
        min_tls_version               = "DYNAMIC"
        origin_certificate            = ""
        origin_sni                    = true
        origin_type                   = "CUSTOMER"
        ports                         = ""
        tls_version_title             = ""
        true_client_ip_client_setting = false
        true_client_ip_header         = "True-Client-IP"
        verification_mode             = "PLATFORM_SETTINGS"
      }
    }
    behavior {
      enhanced_debug {
        enable_debug = false
      }
    }
    children = [
      data.akamai_property_rules_builder.ion_standard_rule_augment_insights.json,
      data.akamai_property_rules_builder.ion_standard_rule_accelerate_delivery.json,
      data.akamai_property_rules_builder.ion_standard_rule_offload_origin.json,
      data.akamai_property_rules_builder.ion_standard_rule_strengthen_security.json,
      data.akamai_property_rules_builder.ion_standard_rule_increase_availability.json,
      data.akamai_property_rules_builder.ion_standard_rule_minimize_payload.json,
    ]
  }
}
