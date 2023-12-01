
grafana_url = "https://rps.n98gt56ti.ru/grafana"

domain_name = "rps.n98gt56ti.ru"

dashboards = [
  { 1 = {
    filename    = "nginx_vhost.json.tftpl"
    folder_name = "Nginx"
    }
  },
  { 2 = {
    filename    = "nginx_http_status.json.tftpl"
    folder_name = "Nginx"
    allow_edits = true
    }
  },
]
