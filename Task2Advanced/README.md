# Интеграция с CI/CD и удалённым хранением состояния

Автоматизируйте развёртывание инфраструктуры через CI/CD, используя удалённое состояние (S3/Minio + backend). Конкретный инструмент для CI/CD не принципиален — вы можете реализовать задачу на Jenkins или в любой другой системе, которая вам ближе и привычнее по опыту.

Для этого:

1. Настройте Terraform-код с backend’ом с использованием S3-совместимого хранилища (minio, Yandex Object Storage, AWS S3).
2. Опишите pipeline с использованием .gitlab-ci.yml или GitHub Actions или другого CI/CD-инструмента:
   * terraform init
   * terraform plan
   * terraform apply (по кнопке или с флагом approval)

README.md опишет детально все скрипты. 

## Отчёт

### Архитектура решения

Terraform state хранится **исключительно** в MinIO — никакого локального `terraform.tfstate` не создаётся. Файл `backend.tf` настраивает S3-совместимый backend с отключёнными AWS-специфичными проверками (`force_path_style = true`, `skip_credentials_validation = true`), что необходимо для работы с MinIO.

### Структура pipeline

```
validate ──► plan ──► apply (dev: auto / stage,prod: ручное) ──► destroy (manual)
```

| Стадия              | Ветка        | Запуск         | Детали                                    |
|---------------------|--------------|----------------|-------------------------------------------|
| `validate`          | любая / MR   | авто           | `terraform validate` + `fmt -check`       |
| `plan`              | любая / MR   | авто           | сохраняет `tfplan` как артефакт на 1 день |
| `apply:dev`         | `dev`        | авто           | `when: on_success`                        |
| `apply:stage`       | `stage`      | **manual ▶**   | `when: manual`                            |
| `apply:prod`        | `main`       | **manual ▶**   | `when: manual`                            |
| `destroy:dev/stage` | соотв. ветка | вручную        | для prod — намеренно отсутствует          |

### Безопасность — ключевые решения

- **Все секреты — только через GitLab CI Variables** (Masked + Protected): `YC_TOKEN`, `MINIO_ACCESS_KEY`, `MINIO_SECRET_KEY`, `SSH_PUBLIC_KEY` — ни один из них не попадает в `.tfvars` или репозиторий
- **`yc_token` помечен `sensitive = true`** в Terraform — значение не появляется в выводе `plan`
- **Версионирование MinIO-бакета** включается скриптом `scripts/init-minio.sh` — позволяет откатить state при случайной порче
- **`.gitignore`** исключает `.terraform/`, `*.tfstate`, `tfplan` — state никогда не попадёт в git
- **Destroy для prod** намеренно не предусмотрен в пайплайне — требует явного ручного аудита

### Инициализация MinIO

```bash
export AWS_ACCESS_KEY_ID=minioadmin
export AWS_SECRET_ACCESS_KEY=minioadmin
bash scripts/init-minio.sh
```

Скрипт создаёт бакет `terraform-state` и включает версионирование через MinIO Client (`mc`).
