$vm_specs ||= {
  'web' => {
    'ram' => 768,
    'cpu' => 1,
    'qty' => 1,
    'ip' => '10', # i.e. last octet in ip address
    'hostonly_net' => true,
    'inventory_groups' => 'web_vms',
  },
  'app' => {
    'ram' => 1024,
    'cpu' => 2,
    'qty' => 2,
    'ip' => '20',
    'inventory_groups' => 'app_vms',
  },
  'db' => {
    'ram' => 2 * 1024,
    'cpu' => 2,
    'qty' => 1,
    'ip' => '30',
    'inventory_groups' => 'mon_vms',
  },
}

$jumphost_vm ||= 'web01'
# $jumphost_ssh_host_port_forward ||= 2222
# $jumphost_external_ip_address ||= 'host.docker.internal'

$vms_os_name ||= 'ubuntu/jammy64' # ubuntu/jammy64 — Ubuntu 22.04

# $vbox_hostonly_network_ip ||= '192.168.219' # used to access virtbox vms from host os or from docker containers
# $vbox_hostonly_proxyjump_ip || = '192.168.219.20'

$vbox_hostonly_proxyjump_ip ||= '192.168.219.21' # used to access virtbox vms from host os or from docker containers
$hostonly_vm ||= 'web01'

$vbox_vm_group_name ||= '' # create vms group in virtualbox ui

$vm_postfix ||= '' # uniqlify vm names (virtbox cannot have two vms with the same name even in different groups)

$vbox_internal_network_name ||= 'intnet' # internal network must exist before launching vagrant up command

# available range for ssh port collision resolving
$host_usable_ssh_ports_range ||= 7000..7100

$use_apt_cacher ||= false # use existing apt-cacher (https://help.ubuntu.com/community/Apt-Cacher%20NG)
$use_apt_cacher && $apt_cacher_address ||= "http://#{%x[grep /mnt/c/Windows/System32/drivers/etc/hosts -e host.docker.internal 2>/dev/null | cut -f1 -d' ' -z]}:3142"

$ssh_public_key_path ||= '~/.ssh/id_rsa.pub' # add existing ssh key to vms (in addition to key autogenerated by vagrant)
$ssh_private_key_path ||= '~/.ssh/id_rsa'

$generated_ssh_config_path ||= './../ansible/ssh_config.local'
$generated_ansible_inventory_path ||= './../ansible/inventories/local/hosts'

$vbox_internal_network_ip ||= '192.168.50'


$create_ssh_config_in_homedir ||= false
$homedir_ssh_config_name ||= ''
$ssh_control_path_dir ||= '/tmp/cm_socket'
