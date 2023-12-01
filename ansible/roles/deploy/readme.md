# Ansible role to install «bingo» app

## prepare db
```console
ap -i inventories/local/ playbooks/deploy.yml -e deploy__app_run_prepare_db_task=true
```
