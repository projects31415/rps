def create_vm(config, vm_name)
  config.vm.define vm_name do |vbox|
    vbox.vm.network "private_network",
      ip: "#{$vbox_internal_network_ip}.#{$vm_specs[vm_name]['ip']}",
      virtualbox__intnet: "#{$vbox_internal_network_name}"

    # if $vm_specs[vm_name].key?('hostonly_net') and $vm_specs[vm_name]['hostonly_net'] == true
    #   vbox.vm.network "private_network",
    #     ip: "#{$vbox_hostonly_network_ip}.#{$vm_specs[vm_name]['ip']}",
    #     virtualbox__intnet: false
    # end

    if $hostonly_vm == vm_name
      vbox.vm.network "private_network",
        ip: $vbox_hostonly_proxyjump_ip,
        virtualbox__intnet: false
    end

    vbox.vm.hostname = vm_name
    if $jumphost_vm == vm_name
      vbox.vm.network "forwarded_port",
        id: "ssh",
        host: $jumphost_ssh_host_port_forward,
        guest: 22
    end

    vbox.vm.provider "virtualbox" do |vbox|
      vbox.name = "#{vm_name}#{$vm_postfix}"
      vbox.customize ["modifyvm", :id, "--memory", $vm_specs[vm_name]['ram']]
      vbox.customize ["modifyvm", :id, "--cpus", $vm_specs[vm_name]['cpu']]
    end
  end
end


def create_vms(config, vm_name)
  (1..$vm_specs[vm_name]['qty'].to_i).each do |server_index|
    config.vm.define "#{vm_name}#{"%02d" % server_index}" do |vbox|
    vbox.vm.hostname = "#{vm_name}#{"%02d" % server_index}"

      vm_internal_ip = "#{$vbox_internal_network_ip}.#{$vm_specs[vm_name]['ip'].to_i + server_index - 1 }"

      vbox.vm.network "private_network",
        ip: vm_internal_ip,
        virtualbox__intnet: "#{$vbox_internal_network_name}"

      # if $vm_specs[vm_name].key?('hostonly_net') and $vm_specs[vm_name]['hostonly_net'] == true
      #   vbox.vm.network "private_network",
      #     ip: "#{$vbox_hostonly_network_ip}.#{$vm_specs[vm_name]['ip'].to_i + server_index - 1 }",
      #     virtualbox__intnet: false
      # end

      if $hostonly_vm == "#{vm_name}#{"%02d" % server_index}"
        vbox.vm.network "private_network",
          ip: $vbox_hostonly_proxyjump_ip,
          virtualbox__intnet: false
      end

      vbox.vm.provider "virtualbox" do |vbox|
        vbox.name = "#{vm_name}#{"%02d" % server_index}#{$vm_postfix}"
        vbox.customize ["modifyvm", :id, "--memory", $vm_specs[vm_name]['ram']]
        vbox.customize ["modifyvm", :id, "--cpus", $vm_specs[vm_name]['cpu']]
      end
    end
  end
end


def add_ssh_public_keys(config)
  ssh_public_key_path_expanded = File.expand_path($ssh_public_key_path)
  if File.file?(ssh_public_key_path_expanded)
    config.vm.provision "shell" do |sh|
      ssh_pub_key = File.readlines(ssh_public_key_path_expanded).first.strip
      sh.inline = <<-SHELL
        echo #{ssh_pub_key} >> /home/vagrant/.ssh/authorized_keys
      SHELL
    end
  end
end


def generate_ssh_config(scalable_vms, non_scalable_vms)
    ssh_config_content = ""

    for vm_name in scalable_vms do
      for server_index in (1..$vm_specs[vm_name]['qty'].to_i) do
        ssh_config_content+= <<-EOF
Host #{vm_name}#{"%02d" % server_index}
    HostName #{$vbox_internal_network_ip}.#{$vm_specs[vm_name]['ip'].to_i + server_index - 1 }
        EOF
      end
    end

    for vm_name in non_scalable_vms do
      ssh_config_content+= <<-EOF
Host #{vm_name}
    HostName #{$vbox_internal_network_ip}.#{$vm_specs[vm_name]['ip']}
EOF
    end

    ssh_config_content+= <<-EOF
Host proxyjump
    # HostName #{$jumphost_external_ip_address}
    HostName #{$vbox_hostonly_proxyjump_ip}

### Proxyjumps #####################################################

Host * !proxyjump
    ProxyJump proxyjump

### Ports ##########################################################

Host proxyjump
    # Port #{$jumphost_ssh_host_port_forward}
    Port 22

### Defaults/Fallbacks #############################################

Host *
    IdentityFile #{$ssh_private_key_path}
    IdentitiesOnly yes
    ServerAliveInterval 60
    ServerAliveCountMax 2
    StrictHostKeyChecking no
    UserKnownHostsFile /dev/null
    Port 22
    User vagrant

    ControlPersist 10m
    ControlMaster auto
    # resulted ControlPath value must not be longer than 107 bytes
    # ControlPath #{$ssh_control_path_dir}/#{$homedir_ssh_config_name}/%C

EOF

    File.write($generated_ssh_config_path, ssh_config_content)
end


def generate_ansible_inventory(scalable_vms, non_scalable_vms)
  ansible_inventory = <<-EOF
[all:vars]
# uses hash %C to avoid "too long for Unix domain socket" error
ansible_ssh_common_args=-F ./ssh_config.local -o ControlMaster=auto -o ControlPersist=10m -o ControlPath=ssh/cm_socket/local.%C
EOF

  for vm_name in scalable_vms do
    ansible_inventory+= "[#{vm_name.gsub('-', '_')}_vms]\n"
    for server_index in (1..$vm_specs[vm_name]['qty'].to_i) do
      ansible_inventory+= <<-EOF
#{vm_name}#{"%02d" % server_index}
      EOF
    end
  end

  for vm_name in non_scalable_vms do
    ansible_inventory+= <<-EOF
[#{vm_name}_vms]
#{vm_name}
EOF
    end

  # puts ansible_inventory
  File.write($generated_ansible_inventory_path, ansible_inventory)
end


# def generate_haproxy_config

# end

def add_apt_cacher_proxy(config)
  config.vm.provision "shell" do |sh|
    sh.inline = <<-SHELL
cat <<EOF > /etc/apt/apt.conf.d/01proxy
// Do not verify peer certificate
Acquire::https::Verify-Peer "false";
// Do not verify that certificate name matches server name
Acquire::https::Verify-Host "false";
Acquire::http { Proxy "#{$apt_cacher_address}"; };
EOF
    SHELL
  end
end


def create_homedir_ssh_config(config_name, control_path, generated_config_path)
  bash_result = %x[bash copy_ssh_config.sh #{config_name} #{control_path} #{File.expand_path(generated_config_path)}]

  puts bash_result
end
