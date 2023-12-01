# simple web-app project

```
.
├── ansible — provision/configure vms
├── terraform — create vps and vms in yandex cloud
├── tests — config for artillery(https://www.artillery.io/docs) rps tests
├── vagrant — for local tests on virtualbox vms (unfinished)
└── readme.md
```

## prereqs:
```
terraform
ansible

docker
yc cli
aws cli
```

```console
alias ag=ansible-galaxy
alias ap=ansible-playbook
alias tf=terraform
```

## create tf s3 backend(terraform/readme.md)

### create vpc
```console
cd $(git rev-parse --show-toplevel)/terraform/vpc
tf init -backend-config=$(git rev-parse --show-toplevel)/terraform/s3_backend_common.tfbackend -backend-config=s3_backend.tfbackend
tf apply
```
### create vms
```console
cd $(git rev-parse --show-toplevel)/terraform/vm
tf init -backend-config=$(git rev-parse --show-toplevel)/terraform/s3_backend_common.tfbackend -backend-config=s3_backend.tfbackend
tf apply
```
## change dns a record for rps.n98gt56ti.ru

### install ansible dependencies
```console
cd $(git rev-parse --show-toplevel)/ansible
ag install -r requirements.yml
```

### disable(comment out) ssl settings in ansible/inventories/cloud/group_templates/web_vms/nginx/sites/application.conf.j2

### vms provisioning
```console
cd $(git rev-parse --show-toplevel)/ansible
ap -i inventories/cloud/ playbooks/web.yml
ap -i inventories/cloud/ playbooks/db.yml
ap -i inventories/local/ playbooks/deploy.yml -e deploy__app_run_prepare_db_task=true
```

### generate ssl certs
```console
sudo certbot certonly --webroot -w /var/www/ -d rps.n98gt56ti.ru --register-unsafely-without-email --agree-tos
```

### enable(uncomment) ssl settings in ansible/inventories/cloud/group_templates/web_vms/nginx/sites/application.conf.j2

### rerun playbook for web vm
```console
ap -i inventories/cloud/ playbooks/web.yml
```

### create terraform grafana acc and grant admin rights
`https://rps.n98gt56ti.ru/grafana/admin/users`

## configure grafana
### create folders and datasources
```console
cd $(git rev-parse --show-toplevel)/terraform/grafana/main
tf init -backend-config=$(git rev-parse --show-toplevel)/terraform/s3_backend_common.tfbackend -backend-config=s3_backend.tfbackend
tf apply
```
### create dashboards
```console
cd $(git rev-parse --show-toplevel)/terraform/grafana/dashboard
tf init -backend-config=$(git rev-parse --show-toplevel)/terraform/s3_backend_common.tfbackend -backend-config=s3_backend.tfbackend
tf apply
```

### indexes for tables to improve db query performance
```
CREATE INDEX sessions_id_idx ON sessions (id);
CREATE INDEX customers_id_idx ON customers (id);
```
### rps tests
```console
docker run --rm -ti --mount type=bind,source=${PWD}/tests,target=/scripts,readonly artilleryio/artillery:1.7.2 run /scripts/sessions.yml
docker run --rm -ti --mount type=bind,source=${PWD}/tests,target=/scripts,readonly artilleryio/artillery:1.7.2 run /scripts/customers.yml
```

### quic/http3 support check:
https://http3check.net/?host=rps.n98gt56ti.ru
or
```console
docker run -it --rm ymuski/curl-http3 curl --http3-only https://rps.n98gt56ti.ru/ -v
```
## grafana access
admin
admin-pass

### nginx statuses dashboard
https://rps.n98gt56ti.ru/grafana/d/f008828c-070b-4e9e-bb89-063ba6d88f59
### nginx vhost stats dashboard
https://rps.n98gt56ti.ru/grafana/d/ZQAsi-Xiz/nginx-vts

### nginx vhost stats
https://rps.n98gt56ti.ru/status_vhost
user: monitoring
password: password


## Notes:
  - vm public ip address changes after vm is stopped/restarted
  - internal ip changes if vm is recreated(tf destroy, tf apply)


## Enhancements:
  - do not use postgres user for connection to db
  - add ci pipelines
  - automate manual steps
    - ssl certs generation
    - tf s3 backend setup
    - postgres index queries
  - create nginx dashboard with stats for each url/endpoint
