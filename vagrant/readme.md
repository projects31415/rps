# modify vm specs:
```
( vb_name='vbox-qolio-avito'
vboxmanage controlvm ${vb_name} poweroff && \
vboxmanage modifyvm ${vb_name} --memory 800 && \
vb startvm ${vb_name} --type headless
)
```
and change in vagrant file new values for permanent change
Ex.:
    ```vbox.customize ["modifyvm", :id, "--memory", "800"] # for modification with vagrant reload```


# generated ssh_config example
```
Host app01
    HostName 192.168.50.10
Host db01
    HostName 192.168.50.20
Host prod01
    HostName 192.168.50.30
Host elastic01
    HostName 192.168.50.40
Host gitlab
    HostName 192.168.50.5
Host kibana
    HostName 192.168.50.6
Host runner
    HostName 192.168.50.7
Host vpn
    HostName 192.168.50.4
Host proxyjump
    HostName host.docker.internal

### Proxyjumps #####################################################

Host * !proxyjump
    ProxyJump proxyjump

### Ports ##########################################################

Host proxyjump
    Port 2222

### Defaults/Fallbacks #############################################

Host *
    IdentityFile ~/.ssh/id_rsa_virtualbox
    IdentitiesOnly yes
    ServerAliveInterval 60
    ServerAliveCountMax 2
    StrictHostKeyChecking no
    UserKnownHostsFile /dev/null
    Port 22
    User vagrant

    ControlPersist 10m
    ControlMaster auto
    ControlPath /tmp/%C

```
