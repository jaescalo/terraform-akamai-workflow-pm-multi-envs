contract_id = "ctr_1-1NC95D"
group_id    = "grp_71960"

property_config = {
  name       = "gitops-dev.demo.com"
  product_id = "prd_Fresca"
}

edge_hostnames = {
  "jaescalo-test-edgekey-net" = {
    ip_behavior   = "IPV6_COMPLIANCE"
    edge_hostname = "jaescalo.test.edgekey.net"
  }
}

property_hostnames = {
  "gitops-dev.demo.com" = {
    cname_from             = "gitops-dev.demo.com"
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
rule_default_origin_hostname = "origin-gitops-dev.demo.com"
rule_traffic_reporting_cp_code = 407946

activation_config = {
  staging = {
    contacts = ["noreply@akamai.com"]
  }
  production = {
    contacts = ["noreply@akamai.com"]
  }
}

activate_latest_on_staging = false
activate_latest_on_production = false