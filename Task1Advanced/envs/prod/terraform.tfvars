env_name       = "prod"
vm_name        = "app-server"
cores          = 8
memory         = 16
disk_size      = 200
disk_type      = "network-ssd-nonreplicated"
boot_disk_size = 30
platform_id    = "standard-v3"
nat            = false

yc_cloud_id    = "YOUR_CLOUD_ID"
yc_folder_id   = "YOUR_FOLDER_ID"
yc_zone        = "ru-central1-a"
subnet_id      = "YOUR_PROD_SUBNET_ID"
image_id       = "fd8ue2nph2v23d0rtfug"
ssh_public_key = "ssh-rsa AAAA... user@prod"
