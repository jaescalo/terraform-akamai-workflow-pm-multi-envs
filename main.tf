module "property" {
  source = "./modules/property"

  providers = {
    akamai = akamai
  }

  contract_id                    = var.contract_id
  group_id                       = var.group_id
  property_config                = var.property_config
  edge_hostnames                 = var.edge_hostnames
  property_hostnames             = var.property_hostnames
  rule_variables                 = var.rule_variables
  rule_default_origin_hostname   = var.rule_default_origin_hostname
  rule_traffic_reporting_cp_code = var.rule_traffic_reporting_cp_code
  activation_config              = var.activation_config
  version_notes                  = var.version_notes
  activate_latest_on_staging     = var.activate_latest_on_staging
  activate_latest_on_production  = var.activate_latest_on_production
}
