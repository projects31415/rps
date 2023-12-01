
variable "folder_id" {
  description = "yandex cloud folder id (yc resource-manager folder list)"
  type        = string
}

variable "aws_profile_for_s3_backend" {
  description = "profile name from aws credentials file"
  type        = string
  default     = "tf-state-acc"
}

variable "tf_state_lock_database_name" {
  type    = string
  default = "terraform-tfstate-locks"
}

variable "bucket_name" {
  description = "s3 storage bucket name. must be unique accross all yandex accs"
  type        = string
  default     = ""
}
