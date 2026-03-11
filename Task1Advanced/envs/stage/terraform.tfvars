env_name       = "stage"
vm_name        = "app-server"
cores          = 4
memory         = 8
disk_size      = 50
disk_type      = "network-ssd"
boot_disk_size = 20
platform_id    = "standard-v3"
nat            = false

yc_cloud_id    = "YOUR_CLOUD_ID"
yc_folder_id   = "YOUR_FOLDER_ID"
yc_zone        = "ru-central1-b"
subnet_id      = "YOUR_STAGE_SUBNET_ID"
image_id       = "fd8ue2nph2v23d0rtfug"
ssh_public_key = "ssh-rsa AAAA... user@stage"
