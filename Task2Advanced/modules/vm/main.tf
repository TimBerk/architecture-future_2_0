resource "yandex_compute_disk" "data" {
  name = "${var.env_name}-${var.vm_name}-data-disk"
  type = var.disk_type
  size = var.disk_size
  labels = { environment = var.env_name, managed_by = "terraform" }
}

resource "yandex_compute_instance" "vm" {
  name        = "${var.env_name}-${var.vm_name}"
  platform_id = var.platform_id

  resources {
    cores  = var.cores
    memory = var.memory
  }

  boot_disk {
    initialize_params {
      image_id = var.image_id
      size     = var.boot_disk_size
    }
  }

  secondary_disk {
    disk_id = yandex_compute_disk.data.id
  }

  network_interface {
    subnet_id = var.subnet_id
    nat       = var.nat
  }

  metadata = {
    ssh-keys = "ubuntu:${var.ssh_public_key}"
  }

  labels = { environment = var.env_name, managed_by = "terraform" }
}
