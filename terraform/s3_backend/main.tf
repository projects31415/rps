terraform {
  backend "s3" {}
}

provider "yandex" {
  folder_id                = var.folder_id
  service_account_key_file = "./../credentials.json"
}

provider "aws" {
  skip_region_validation      = true
  skip_credentials_validation = true
  skip_requesting_account_id  = true
  shared_credentials_files    = ["./../credentials"]
  profile                     = var.aws_profile_for_s3_backend
}
