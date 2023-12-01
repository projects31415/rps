# simple nginx-rps project

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

### install ansible dependencies
```console
cd ansible
ag install -r requirements.yml
```

### simple install (no monitoring,no tf remote backend)
```console
```


### install with monitoring and tf remote backend
