# Модульная инфраструктура для нескольких сред

Вам нужно создать универсальный модуль Terraform, который можно использовать для разных окружений (dev, stage, prod).

1. Реализовать модуль vm_module (в папке modules/vm/) со следующими параметрами:
    * Количество ядер;
    * Объём RAM;
    * Подключаемый диск;
    * Subnet ID;
    * SSH-ключ.

2. Сформировать три окружения, каждое со своей конфигурацией:
   * /envs/dev/
   * /envs/stage/
   * /envs/prod/

3. В каждом окружении используйте свой .tfvars, подставляя разные параметры в модуль.

```bash
/TaskAdvanced1/
  ├── modules/
  │   └── vm/
  │       ├── main.tf
  │       ├── variables.tf
  │       └── outputs.tf
  └── envs/
      ├── dev/
      ├── stage/
      └── prod/ 
```

    * `main.tf` — ресурсы ВМ + подключаемый диск + сеть.
    * `variables.tf` — входные параметры модуля (см. интерфейс ниже). 
    * `outputs.tf` — полезные выходы (id ВМ, ip-адрес, имя, id диска и т. д.).

Внутри модуля не должно быть никаких захардкоженных значений окружений — всё через переменные. 

README.md описывает, что делает модуль, параметры, выходы и как его запустить для каждого окружения.  

Когда задание будет готово, загрузите переиспользуемый модуль Terraform в директорию Task1Advanced в рамках пул-реквеста. 

Обратите внимание, что ревьюер будет также смотреть на переиспользуемость модуля в разных окружениях, наличие переменных, правильную структуру, корректный `output`, читаемость кода и применение окружения с разными конфигурациями через terraform `apply -var-file=...`


## Отчёт

```
TaskAdvanced1/
├── modules/
│   └── vm/
│       ├── main.tf        # ресурсы: yandex_compute_instance + yandex_compute_disk
│       ├── variables.tf   # входные параметры модуля
│       └── outputs.tf     # выходные значения
└── envs/
    ├── dev/
    │   ├── main.tf
    │   ├── variables.tf
    │   └── terraform.tfvars
    ├── stage/
    │   ├── main.tf
    │   ├── variables.tf
    │   └── terraform.tfvars
    └── prod/
        ├── main.tf
        ├── variables.tf
        └── terraform.tfvars
```

### Параметры модуля (`modules/vm/variables.tf`)

| Переменная      | Тип    | Обязательная | Описание                                      |
|-----------------|--------|:------------:|-----------------------------------------------|
| `env_name`      | string | ✅           | Имя окружения (dev / stage / prod)            |
| `vm_name`       | string | ✅           | Имя ВМ (без префикса окружения)               |
| `cores`         | number | ✅           | Количество ядер CPU                           |
| `memory`        | number | ✅           | Объём RAM в ГБ                                |
| `disk_size`     | number | ✅           | Размер подключаемого дата-диска в ГБ          |
| `disk_type`     | string | ❌           | Тип диска (default: `network-ssd`)            |
| `boot_disk_size`| number | ❌           | Размер загрузочного диска в ГБ (default: 20)  |
| `subnet_id`     | string | ✅           | ID подсети                                    |
| `ssh_public_key`| string | ✅           | Публичный SSH-ключ                            |
| `image_id`      | string | ✅           | ID образа загрузочного диска                  |
| `platform_id`   | string | ❌           | Платформа Yandex Cloud (default: standard-v3) |
| `nat`           | bool   | ❌           | Включить внешний IP (default: false)          |

### Выходы модуля (`modules/vm/outputs.tf`)

| Output           | Описание                              |
|------------------|---------------------------------------|
| `vm_id`          | ID созданной ВМ                       |
| `vm_name`        | Полное имя ВМ (env_name-vm_name)      |
| `internal_ip`    | Внутренний IP-адрес                   |
| `external_ip`    | Внешний IP (NAT), если включён        |
| `data_disk_id`   | ID подключённого дата-диска           |
| `data_disk_name` | Имя подключённого дата-диска          |

### Конфигурации окружений

| Параметр        | dev  | stage | prod  |
|-----------------|------|-------|-------|
| CPU cores       | 2    | 4     | 8     |
| RAM (ГБ)        | 2    | 8     | 16    |
| Дата-диск (ГБ)  | 20   | 50    | 200   |
| Тип диска       | HDD  | SSD   | SSD NR|
| NAT             | true | false | false |

### Запуск

#### Предварительные условия

1. Установить [Terraform](https://developer.hashicorp.com/terraform/install) ≥ 1.3
2. Получить IAM-токен Yandex Cloud: `yc iam create-token`
3. Заполнить реальные значения в `terraform.tfvars` нужного окружения

#### Команды

```bash
# Инициализация (выполняется один раз для каждого окружения)
cd envs/dev
terraform init

# Просмотр плана изменений
terraform plan -var="yc_token=<TOKEN>" -var-file=terraform.tfvars

# Применение
terraform apply -var="yc_token=<TOKEN>" -var-file=terraform.tfvars

# Уничтожение ресурсов
terraform destroy -var="yc_token=<TOKEN>" -var-file=terraform.tfvars
```

> **Безопасность:** не коммитьте `yc_token` в репозиторий.
> Передавайте его через переменную окружения или CI/CD secrets:
> ```bash
> export TF_VAR_yc_token=$(yc iam create-token)
> terraform apply -var-file=terraform.tfvars
> ```

### Добавление нового окружения

1. Скопировать любую папку из `envs/`, например `cp -r envs/stage envs/uat`
2. Отредактировать `terraform.tfvars` с нужными параметрами
3. Запустить `terraform init && terraform apply -var-file=terraform.tfvars`
