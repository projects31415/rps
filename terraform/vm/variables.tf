# variable "network_name" {
#   type    = string
#   default = "default"
# }

variable "folder_id" {
  type = string
}


#  ---------------------------------------------------------------------------------
#  vpc remote state
#  ---------------------------------------------------------------------------------

variable "vpc_remote_state_bucket" {
  description = "Name of s3 bucket"
  type        = string
}

variable "vpc_remote_state_path" {
  description = "Path to remote state file in s3 bucket. Ex.: project/ru-7/vpc/terraform.tfstate"
  type        = string
}

variable "vpc_remote_state_region" {
  type    = string
  default = "us-east-1"
}

variable "vpc_remote_state_profile" {
  description = "Name of a profile from file with credentials for s3 bucket"
  type        = string
  default     = "yandex"
}

variable "vpc_remote_state_creds_file" {
  description = "Path to a file with credentilas for s3 bucket"
  type        = string
  default     = "./../../../../../credentials"
}

variable "vpc_remote_state_endpoint" {
  type    = string
  default = "storage.yandexcloud.net"
}

#  ---------------------------------------------------------------------------------
#  vm vars
#  ---------------------------------------------------------------------------------

variable "ssh_user_public_key" {
  description = "Ssh public key. Must begin with 'ssh-rsa', 'ssh-ed25519', 'ecdsa-sha2-nistp256', 'ecdsa-sha2-nistp384', or 'ecdsa-sha2-nistp521'"
  type        = string
}
