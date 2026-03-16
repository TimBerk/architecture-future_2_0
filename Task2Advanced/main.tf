module "vm" {
  source = "./modules/vm"

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
