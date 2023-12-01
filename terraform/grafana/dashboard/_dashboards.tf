resource "grafana_dashboard" "dashboard" {
  for_each = { for dashboard in var.dashboards : keys(dashboard)[0] => values(dashboard)[0] }

  config_json = templatefile("${var.dashboards_dir}/${each.value.filename}", {
    tf_prometheus_data_source_uid = data.grafana_data_source.prometheus.uid
    tf_domain_name                = var.domain_name
    tf_host_name                  = var.host_name
    tf_allow_edits                = each.value.allow_edits
  })

  folder    = [for folder in data.grafana_folders.folders.folders : folder if folder.title == each.value.folder_name][0].uid
  message   = each.value.message
  org_id    = each.value.org_id
  overwrite = each.value.overwrite
}
