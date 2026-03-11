terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = ">= 0.84"
    }
  }
}

provider "yandex" {
  token     = var.yc_token
  cloud_id  = var.yc_cloud_id
  folder_id = var.yc_folder_id
  zone      = var.yc_zone
}

module "vm" {
  source = "../../modules/vm"

  env_name       = var.env_name
  vm_name        = var.vm_name
  cores          = var.cores
  memory         = var.memory
  disk_size      = var.disk_size
  disk_type      = var.disk_type
  boot_disk_size = var.boot_disk_size
  subnet_id      = var.subnet_id
  ssh_public_key = var.ssh_public_key
  image_id       = var.image_id
  platform_id    = var.platform_id
  nat            = var.nat
}

output "vm_id"       { value = module.vm.vm_id }
output "vm_name"     { value = module.vm.vm_name }
output "internal_ip" { value = module.vm.internal_ip }
output "external_ip" { value = module.vm.external_ip }
output "disk_id"     { value = module.vm.data_disk_id }
