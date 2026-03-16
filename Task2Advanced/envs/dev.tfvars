env_name       = "dev"
vm_name        = "app-server"
cores          = 2
memory         = 2
disk_size      = 20
disk_type      = "network-hdd"
boot_disk_size = 15
platform_id    = "standard-v3"
nat            = true
yc_zone        = "ru-central1-a"
image_id       = "fd8ue2nph2v23d0rtfug"
# Secrets (yc_token, yc_cloud_id, yc_folder_id, subnet_id, ssh_public_key)
# передаются через CI/CD Variables — не хранятся в этом файле
