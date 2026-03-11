variable "env_name" {
  description = "Environment name (dev, stage, prod)"
  type        = string
}

variable "vm_name" {
  description = "Name of the virtual machine"
  type        = string
}

variable "cores" {
  description = "Number of CPU cores"
  type        = number
}

variable "memory" {
  description = "Amount of RAM in GB"
  type        = number
}

variable "disk_size" {
  description = "Size of the attached disk in GB"
  type        = number
}

variable "disk_type" {
  description = "Type of the attached disk (e.g. network-ssd, network-hdd)"
  type        = string
  default     = "network-ssd"
}

variable "subnet_id" {
  description = "Subnet ID to attach the VM to"
  type        = string
}

variable "ssh_public_key" {
  description = "Public SSH key for VM access"
  type        = string
}

variable "image_id" {
  description = "Boot disk image ID"
  type        = string
}

variable "platform_id" {
  description = "Yandex Cloud platform ID"
  type        = string
  default     = "standard-v3"
}

variable "boot_disk_size" {
  description = "Boot disk size in GB"
  type        = number
  default     = 20
}

variable "nat" {
  description = "Enable NAT for external access"
  type        = bool
  default     = false
}
