
grafana_url = "https://rps.n98gt56ti.ru/grafana"

folders = [
  { 0 = {
    title = "Nginx"
    }
  },
]

# prometheus_url = "http://192.168.50.30:9090/prometheus"


vm_remote_state_bucket     = "n98gt-tf-state-rps"
vm_remote_state_path       = "rps/vm/terraform.tfstate"
vm_remote_state_region     = "us-east-1"
vm_remote_state_profile    = "tf-state-acc"
vm_remote_state_creds_file = "./../../credentials"
vm_remote_state_endpoint   = "storage.yandexcloud.net"
