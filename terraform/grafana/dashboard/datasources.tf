data "grafana_folders" "folders" {}

data "grafana_data_source" "prometheus" {
  name = "Prometheus"
}
