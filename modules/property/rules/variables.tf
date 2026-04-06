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
