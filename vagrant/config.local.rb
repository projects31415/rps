# $vm_specs ||= {
#   'web' => {
#     'ram' => 768,
#     'cpu' => 1,
#     'qty' => 1,
#     'ip' => '10', # i.e. last octet in ip address
#     'hostonly_net' => true,
#   },
#   'db' => {
#     'ram' => 1536,
#     'cpu' => 1,
#     'qty' => 2,
#     'ip' => '20',
#   },
#   'mon' => {
#     'ram' => 2048,
#     'cpu' => 1,
#     'qty' => 1,
#     'ip' => '30',
#   },
#   'db-backup' => {
#     'ram' => 1024,
#     'cpu' => 1,
#     'qty' => 1,
#     'ip' => '6',
#   },
# }





$jumphost_vm ||= 'web01'
# $jumphost_ssh_host_port_forward = 2224

$vbox_internal_network_name = 'mynetwork-rps'

$host_usable_ssh_ports_range = 7061..7080

$use_apt_cacher = true

$vm_postfix ||= '_rps'

$vbox_vm_group_name = 'rps'

$ssh_public_key_path = '~/.ssh/id_rsa_virtualbox.pub'
$ssh_private_key_path = '~/.ssh/id_rsa_virtualbox'

$create_ssh_config_in_homedir = true
$homedir_ssh_config_name = 'config_vbox_rps'
