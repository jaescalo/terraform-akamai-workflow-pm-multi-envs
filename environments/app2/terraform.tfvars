contract_id = "ctr_1-1NC95D"
group_id    = "grp_71960"

property_config = {
  name       = "temp-template"
  product_id = "prd_Fresca"
}

edge_hostnames = {
}

property_hostnames = {
  "app1.jaescalo.online" = {
    cname_from             = "app1.jaescalo.online"
    cname_to               = "app1.jaescalo.online.edgekey.net"
    cert_provisioning_type = "CCM"
    ccm_certificates = {
      ecdsa_cert_id = "4161"
    }
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
rule_default_origin_hostname = "app1-origin.jaescalo.online"
rule_traffic_reporting_cp_code = 407946

activation_config = {
  staging = {
    contacts = []
    note     = ""
  }
  production = {
    contacts = []
    note     = ""
  }
}

version_notes = ""

activate_latest_on_staging = false
activate_latest_on_production = false
