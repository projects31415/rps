provider "yandex" {
  folder_id                = var.folder_id
  service_account_key_file = "./../credentials.json"
}

terraform {
  backend "s3" {}
}
