resource "grafana_data_source" "prometheus" {
  access_mode              = var.prometheus_access_mode
  basic_auth_enabled       = var.prometheus_basic_auth_enabled
  basic_auth_username      = var.prometheus_basic_auth_username
  database_name            = var.prometheus_database_name
  http_headers             = length(var.prometheus_http_headers) == 0 ? null : var.prometheus_http_headers
  is_default               = var.prometheus_is_default
  json_data_encoded        = jsonencode(var.prometheus_json_data_encoded)
  name                     = "Prometheus"
  org_id                   = var.prometheus_org_id
  secure_json_data_encoded = length(var.prometheus_secure_json_data_encoded) == 0 ? null : jsonencode(var.prometheus_secure_json_data_encoded)
  type                     = "prometheus"
  uid                      = var.prometheus_uid
  url                      = "http://${data.terraform_remote_state.vm.outputs.web_vm_info.network_interface[0].ip_address}:9090/prometheus"
  username                 = var.prometheus_username
}
