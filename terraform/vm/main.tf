provider "yandex" {
  folder_id                = var.folder_id
  service_account_key_file = "./../credentials.json"
}

terraform {
  backend "s3" {}
}

data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket                  = var.vpc_remote_state_bucket
    key                     = var.vpc_remote_state_path
    region                  = var.vpc_remote_state_region
    profile                 = var.vpc_remote_state_profile
    shared_credentials_file = var.vpc_remote_state_creds_file
    endpoint                = var.vpc_remote_state_endpoint

    skip_region_validation      = true
    skip_credentials_validation = true
  }
}
