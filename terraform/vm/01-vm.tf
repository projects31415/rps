module "web_vm" {
  source = "git::https://gitlab.com/terraform_modules3/yandex/tf_module_yandex_vm.git?ref=0.1.1"

  name = "web"

  folder_id           = var.folder_id
  subnet_id           = data.terraform_remote_state.vpc.outputs.private_subnets["10.128.0.0/24"].subnet_id
  ssh_user_public_key = var.ssh_user_public_key

  disk_type = "network-hdd"

  image_family = "ubuntu-2204-lts"

  attach_public_ip = true

  allow_stopping_for_update = true

  core_fraction  = 50
  is_preemptible = true
  cpu_cores      = 2
  memory_gb      = 4
}

module "app_vm" {
  source = "git::https://gitlab.com/terraform_modules3/yandex/tf_module_yandex_vm.git?ref=0.1.1"
  count  = 2

  name = "app-${count.index + 1}"

  folder_id           = var.folder_id
  subnet_id           = data.terraform_remote_state.vpc.outputs.private_subnets["10.128.0.0/24"].subnet_id
  ssh_user_public_key = var.ssh_user_public_key

  disk_type = "network-hdd"

  image_family = "ubuntu-2204-lts"

  allow_stopping_for_update = true

  attach_public_ip = true

  core_fraction  = 50
  is_preemptible = true
  cpu_cores      = 2
  memory_gb      = 2
}

module "db_vm" {
  source = "git::https://gitlab.com/terraform_modules3/yandex/tf_module_yandex_vm.git?ref=0.1.1"

  name = "db"

  folder_id           = var.folder_id
  subnet_id           = data.terraform_remote_state.vpc.outputs.private_subnets["10.128.0.0/24"].subnet_id
  ssh_user_public_key = var.ssh_user_public_key

  disk_type = "network-hdd"

  image_family = "ubuntu-2204-lts"

  allow_stopping_for_update = true

  attach_public_ip = true

  core_fraction  = 50
  is_preemptible = true
  cpu_cores      = 2
  memory_gb      = 2
}
