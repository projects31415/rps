terraform {
  required_version = ">= 1.3.0"

  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "0.92"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "5.1.0"
    }
  }
}
