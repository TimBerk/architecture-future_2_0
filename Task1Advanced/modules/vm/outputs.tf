output "vm_id" {
  description = "ID of the created VM"
  value       = yandex_compute_instance.vm.id
}

output "vm_name" {
  description = "Name of the created VM"
  value       = yandex_compute_instance.vm.name
}

output "internal_ip" {
  description = "Internal IP address of the VM"
  value       = yandex_compute_instance.vm.network_interface[0].ip_address
}

output "external_ip" {
  description = "External (NAT) IP address of the VM, if enabled"
  value       = try(yandex_compute_instance.vm.network_interface[0].nat_ip_address, null)
}

output "data_disk_id" {
  description = "ID of the attached data disk"
  value       = yandex_compute_disk.data.id
}

output "data_disk_name" {
  description = "Name of the attached data disk"
  value       = yandex_compute_disk.data.name
}
