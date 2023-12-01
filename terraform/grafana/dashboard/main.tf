terraform {
  backend "s3" {}
}

provider "grafana" {
  url                  = var.grafana_url
  auth                 = var.grafana_auth
  insecure_skip_verify = var.insecure_skip_verify
}
