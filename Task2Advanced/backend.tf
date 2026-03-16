terraform {
  backend "s3" {
    # S3-совместимый MinIO endpoint
    endpoint = "http://minio:9000"
    bucket   = "terraform-state"
    key      = "future20/vm/terraform.tfstate"
    region   = "us-east-1"   # MinIO требует любое non-empty значение

    # Отключаем AWS-специфичные проверки
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    skip_region_validation      = true
    force_path_style            = true

    # Credentials задаются через переменные окружения:
    #   AWS_ACCESS_KEY_ID     = MINIO_ACCESS_KEY
    #   AWS_SECRET_ACCESS_KEY = MINIO_SECRET_KEY
  }
}
