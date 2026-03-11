env_name       = "dev"
vm_name        = "app-server"
cores          = 2
memory         = 2
disk_size      = 20
disk_type      = "network-hdd"
boot_disk_size = 15
platform_id    = "standard-v3"
nat            = true

# Fill in your actual values:
yc_cloud_id    = "YOUR_CLOUD_ID"
yc_folder_id   = "YOUR_FOLDER_ID"
yc_zone        = "ru-central1-a"
subnet_id      = "YOUR_DEV_SUBNET_ID"
image_id       = "fd8ue2nph2v23d0rtfug"  # Ubuntu 22.04
ssh_public_key = "ssh-rsa AAAA... user@dev"
