contract_id = "ctr_1-1NC95D"
group_id    = "grp_71960"

property_config = {
  name       = "gitops-prod.demo.com"
  product_id = "prd_Fresca"
}

edge_hostnames = {
  "jaescalo-test-edgekey-net" = {
    ip_behavior   = "IPV6_COMPLIANCE"
    edge_hostname = "jaescalo.test.edgekey.net"
  }
}

property_hostnames = {
  "gitops-prod.jaescalo.online" = {
    cname_from             = "gitops-prod.jaescalo.online"
    cname_to               = "jaescalo.test.edgekey.net"
    cert_provisioning_type = "CPS_MANAGED"
  }
}

rule_variables = {
  "pmuser_example_1" = {
    name        = "PMUSER_EXAMPLE_1"
    description = "Just an example"
    value       = "1"
    hidden      = false
    sensitive   = false
  }
  "pmuser_example_2" = {
    name        = "PMUSER_EXAMPLE_2"
    description = "Another example"
    value       = "2"
    hidden      = true
    sensitive   = false
  }
}
rule_default_origin_hostname = "origin-gitops-prod.demo.com"
rule_traffic_reporting_cp_code = 407946

activation_config = {
  staging = {
    contacts = ["noreply@akamai.com"]
  }
  production = {
    contacts = ["noreply@akamai.com"]
  }
}

activate_latest_on_staging = true
activate_latest_on_production = false

import_property_id = "prp_833332,ctr_1-1NC95D,grp_71960,17"
import_ehn_id = "ehn_4874468,ctr_1-1NC95D,grp_71960"