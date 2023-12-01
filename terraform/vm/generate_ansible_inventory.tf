resource "local_file" "ansible_inventory" {
  filename        = "${path.module}/../../ansible/inventories/cloud/hosts"
  file_permission = "644"
  content = templatefile("${path.module}/templates/hosts.tftpl", {
    web_ip_addrs = {
      "${module.web_vm.vm_info.name}" = "${module.web_vm.vm_info.network_interface[0].ip_address}",
    },
    app_ip_addrs = {
      "${module.app_vm[0].vm_info.name}" = "${module.app_vm[0].vm_info.network_interface[0].ip_address}",
      "${module.app_vm[1].vm_info.name}" = "${module.app_vm[1].vm_info.network_interface[0].ip_address}",
    },
    db_ip_addrs = {
      "${module.db_vm.vm_info.name}" = "${module.db_vm.vm_info.network_interface[0].ip_address}",
    },
    bastion_ip_addr = "${module.web_vm.vm_info.network_interface[0].nat_ip_address}"
    }
  )
}
