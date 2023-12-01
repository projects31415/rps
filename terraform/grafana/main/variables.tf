
variable "grafana_url" {
  description = "The root URL of a Grafana server E.g.: http://grafana.example.com/"
  type        = string
}

variable "grafana_auth" {
  description = "API token, basic auth in the username:password"
  type        = string
}

variable "insecure_skip_verify" {
  description = "Skip TLS certificate verification"
  type        = bool
  default     = false
}



#  ---------------------------------------------------------------------------------
#  vpc remote state
#  ---------------------------------------------------------------------------------

variable "vm_remote_state_bucket" {
  description = "Name of s3 bucket"
  type        = string
}

variable "vm_remote_state_path" {
  description = "Path to remote state file in s3 bucket. Ex.: project/ru-7/vpc/terraform.tfstate"
  type        = string
}

variable "vm_remote_state_region" {
  type    = string
  default = "us-east-1"
}

variable "vm_remote_state_profile" {
  description = "Name of a profile from file with credentials for s3 bucket"
  type        = string
  default     = "yandex"
}

variable "vm_remote_state_creds_file" {
  description = "Path to a file with credentilas for s3 bucket"
  type        = string
  default     = "./../../../../../credentials"
}

variable "vm_remote_state_endpoint" {
  type    = string
  default = "storage.yandexcloud.net"
}







# #  ---------------------------------------------------------------------------------
# #  Telegram contact point
# #  ---------------------------------------------------------------------------------

# variable "telegram_token" {
#   description = "The Telegram bot token"
#   type        = string
# }

# variable "telegram_contact_point_name" {
#   description = "The Telegram bot token"
#   type        = string
#   default     = "Telegram"
# }

# variable "telegram_disable_notifications" {
#   description = "Receive a notification with no sound"
#   type        = bool
#   default     = false
# }

# variable "telegram_disable_resolve_message" {
#   description = "Disable sending resolve [OK] messages"
#   type        = bool
#   default     = false
# }

# variable "telegram_disable_web_page_preview" {
#   description = "Disables link previews for links in the message"
#   type        = bool
#   default     = false
# }

# variable "telegram_protect_content" {
#   description = "Protect the contents of the message from forwarding and saving"
#   type        = bool
#   default     = false
# }

# variable "telegram_message" {
#   description = "Templated content of the message"
#   type        = string
#   default     = ""
# }

# variable "telegram_parse_mode" {
#   description = "Mode for parsing entities in the message text. Supported: None, Markdown, MarkdownV2, and HTML"
#   type        = string
#   default     = "HTML"
# }

# variable "telegram_chat_id" {
#   description = "Chat ID to send messages to"
#   type        = string
# }

#  ---------------------------------------------------------------------------------
#  Folders
#  ---------------------------------------------------------------------------------

variable "folders" {
  description = <<EOT
  Example:
  folders = [
    { 0 = {
      title = "Dev environment"
      }
    },
  ]
  EOT

  type = list(map(
    object({
      title                        = string
      org_id                       = optional(string)
      prevent_destroy_if_not_empty = optional(bool, false)
      uid                          = optional(string)
    }))
  )
  default = []
}

#  ---------------------------------------------------------------------------------
#  Prometheus datasource
#  ---------------------------------------------------------------------------------

variable "prometheus_url" {
  description = "The URL for the data source"
  type        = string
  default     = "http://localhost:9090/prometheus"
}

variable "prometheus_org_id" {
  description = "The Organization ID. If not set, the Org ID defined in the provider block will be used."
  type        = string
  default     = "1"
}

variable "prometheus_is_default" {
  description = "Whether to set the data source as default. This should only be true to a single data source"
  type        = bool
  default     = false
}

variable "prometheus_json_data_encoded" {
  description = "can be used to pass configuration options to the data source"
  type = object({
    cacheLevel                    = optional(string, "High")
    disableRecordingRules         = optional(bool, false)
    httpMethod                    = optional(string, "POST")
    incrementalQueryOverlapWindow = optional(string, "10m")
    manageAlerts                  = optional(bool, true)
    prometheusType                = optional(string, "Prometheus")
  })
  default = {}
}

variable "prometheus_uid" {
  description = "Unique identifier. If unset, this will be automatically generated."
  type        = string
  default     = null
}


variable "prometheus_access_mode" {
  description = "The method by which Grafana will access the data source: proxy or direct"
  type        = string
  default     = "proxy"
}


variable "prometheus_basic_auth_enabled" {
  description = "Enable basic auth for the data source"
  type        = bool
  default     = false
}


variable "prometheus_basic_auth_username" {
  description = "Basic auth username"
  type        = string
  default     = null
}


variable "prometheus_database_name" {
  description = "The name of the database to use on the selected data source server"
  type        = string
  default     = null
}


variable "prometheus_http_headers" {
  description = "Custom HTTP headers"
  type        = map(string)
  default     = {}
  sensitive   = true
}

variable "prometheus_secure_json_data_encoded" {
  description = "Json data to pass secure configuration options to the data source"
  type        = map(string)
  default     = {}
  sensitive   = true
}

variable "prometheus_username" {
  description = "The username to use to authenticate to the data source"
  type        = string
  default     = null
}
