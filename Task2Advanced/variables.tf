# ── Yandex Cloud credentials (передаются через CI/CD secrets) ─────────────
variable "yc_token"     { type = string; sensitive = true }
variable "yc_cloud_id"  { type = string }
variable "yc_folder_id" { type = string }
variable "yc_zone"      { type = string; default = "ru-central1-a" }

# ── VM parameters ─────────────────────────────────────────────────────────
variable "env_name"       { type = string }
variable "vm_name"        { type = string; default = "app-server" }
variable "cores"          { type = number }
variable "memory"         { type = number }
variable "disk_size"      { type = number }
variable "disk_type"      { type = string; default = "network-ssd" }
variable "boot_disk_size" { type = number; default = 20 }
variable "subnet_id"      { type = string }
variable "ssh_public_key" { type = string }
variable "image_id"       { type = string }
variable "platform_id"    { type = string; default = "standard-v3" }
variable "nat"            { type = bool;   default = false }
