terraform {
  required_providers {
    akamai = {
      source  = "akamai/akamai"
      version = ">= 10.0.0"
    }
  }
  required_version = ">= 1.0"
}

output "rules" {
  value = data.akamai_property_rules_builder.ion_standard_rule_default.json
}

output "rule_format" {
  value = data.akamai_property_rules_builder.ion_standard_rule_default.rule_format
}