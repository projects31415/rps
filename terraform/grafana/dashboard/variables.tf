
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

variable "dashboards_dir" {
  description = <<EOT
  Path to dir containing dashboards definintions in .json files

  Example dir structure:
  dashboards/
  ├── nginx.json
  ├── mysql.json
  └── node_exporter.json

  EOT
  type        = string
  default     = "./dashboards"
}

variable "dashboards" {
  description = <<EOT
  Example:
  dashboards = [
    { 0 = {
      filename    = "mysql.json"
      folder_name = "Dev environment"
      }
    },
    { 1 = {
      filename    = "nginx.json"
      folder_name = "Dev environment"
      }
    },
  ]
  EOT

  type = list(map(
    object({
      filename    = string
      folder_name = optional(string)
      message     = optional(string)
      org_id      = optional(string)
      overwrite   = optional(bool)
      allow_edits = optional(bool, true)
    }))
  )
  default = []
}

variable "domain_name" {
  description = "Applicatoin domain name for grafana dasboard"
  type        = string
  default     = "localhost"
}

variable "host_name" {
  description = "Web server hostname for grafana dasboard"
  type        = string
  default     = "web01"
}
