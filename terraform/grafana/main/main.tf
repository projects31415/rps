terraform {
  backend "s3" {}
}

provider "grafana" {
  url                  = var.grafana_url
  auth                 = var.grafana_auth
  insecure_skip_verify = var.insecure_skip_verify
}

# get prometheus ip for grafana datasource
data "terraform_remote_state" "vm" {
  backend = "s3"
  config = {
    bucket                  = var.vm_remote_state_bucket
    key                     = var.vm_remote_state_path
    region                  = var.vm_remote_state_region
    profile                 = var.vm_remote_state_profile
    shared_credentials_file = var.vm_remote_state_creds_file
    endpoint                = var.vm_remote_state_endpoint

    skip_region_validation      = true
    skip_credentials_validation = true
  }
}
