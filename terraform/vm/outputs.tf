# output "network_id" {
#   value = module.vpc.vpc_id
# }

# output "private_subnets" {
#   value = module.vpc.private_subnets
# }

output "web_vm_info" {
  value = module.web_vm.vm_info
}
