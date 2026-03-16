# События целевой событийной архитектуры

**Домен «Пациент» (Patient Domain)**

| № | Событие                | Описание                                     | Источник       | Подписчики                                 |
|---|------------------------|----------------------------------------------|----------------|--------------------------------------------|
| 1 | **PatientRegistered**  | Пациент зарегистрирован в системе            | Patient Domain | Fintech Domain, EMR Domain, Billing Domain |
| 2 | **PatientVerified**    | Пациент верифицирован (документы проверены)  | Patient Domain | Fintech Domain, EMR Domain, AI Services    |
| 3 | **PatientDataUpdated** | Контактные данные пациента обновлены         | Patient Domain | Все домены (через CDP)                     |
| 4 | **PatientMerged**      | Дублирующиеся профили пациентов объединены   | Patient Domain | Все домены                                 |
| 5 | **ConsentGranted**     | Пациент дал согласие на обработку данных     | Patient Domain | Marketing Domain, AI Services              |
| 6 | **ConsentRevoked**     | Пациент отозвал согласие на обработку данных | Patient Domain | Marketing Domain, AI Services              |

**Домен «Медицинская карта» (EMR Domain)**

| № | Событие                   | Описание                                         | Источник   | Подписчики                        |
|---|---------------------------|--------------------------------------------------|------------|-----------------------------------|
| 1 | **EncounterStarted**      | Начат прием пациента врачом                      | EMR Domain | Billing Domain, Inventory Domain  |
| 2 | **EncounterCompleted**    | Прием пациента завершен                          | EMR Domain | Billing Domain, Reporting Domain  |
| 3 | **DiagnosisRecorded**     | Зафиксирован диагноз (код МКБ)                   | EMR Domain | AI Services, Reporting Domain     |
| 4 | **PrescriptionIssued**    | Выписан рецепт на лекарство                      | EMR Domain | Inventory Domain, Pharmacy Domain |
| 5 | **ReferralCreated**       | Создано направление на исследование/консультацию | EMR Domain | Diagnostic Domain, Billing Domain |
| 6 | **VitalsRecorded**        | Зафиксированы показатели жизнедеятельности       | EMR Domain | AI Services, Reporting Domain     |
| 7 | **MedicalHistoryUpdated** | Обновлена история болезни                        | EMR Domain | Reporting Domain (обезличенно)    |

**Домен «Медицинские исследования» (Diagnostic Domain)**

| № | Событие                   | Описание                                                       | Источник          | Подписчики                   |
|---|---------------------------|----------------------------------------------------------------|-------------------|------------------------------|
| 1 | **StudyUploaded**         | Исследование (снимки, результаты анализов) загружено в систему | Diagnostic Domain | AI Services, EMR Domain      |
| 2 | **AIPredictionAvailable** | ИИ-сервис завершил анализ исследования и предсказание готово   | Diagnostic Domain | EMR Domain, Reporting Domain |
| 3 | **StudyInterpreted**      | Врач интерпретировал результаты исследования                   | Diagnostic Domain | EMR Domain, AI Services      |
| 4 | **StudyShared**           | Исследование отправлено внешнему партнеру                      | Diagnostic Domain | Partner Domain, Audit Domain |
| 5 | **QualityControlPassed**  | Исследование прошло контроль качества                          | Diagnostic Domain | Reporting Domain             |

**Домен «Финтех» (Fintech Domain)**

| № | Событие                  | Описание                                        | Источник       | Подписчики                                          |
|---|--------------------------|-------------------------------------------------|----------------|-----------------------------------------------------|
| 1 | **AccountOpened**        | Открыт банковский счет клиенту                  | Fintech Domain | Patient Domain, Billing Domain                      |
| 2 | **AccountClosed**        | Закрыт банковский счет                          | Fintech Domain | Patient Domain, Billing Domain                      |
| 3 | **TransactionProcessed** | Проведена финансовая транзакция                 | Fintech Domain | Billing Domain, Reporting Domain                    |
| 4 | **LoanIssued**           | Выдан кредит клиенту                            | Fintech Domain | Billing Domain, Reporting Domain, Collection Domain |
| 5 | **LoanRepaid**           | Кредит погашен полностью или частично           | Fintech Domain | Billing Domain, Reporting Domain                    |
| 6 | **PaymentReceived**      | Получен платеж от клиента или контрагента       | Fintech Domain | Billing Domain, Notification Domain                 |
| 7 | **PaymentFailed**        | Платеж не прошел (недостаточно средств, ошибка) | Fintech Domain | Billing Domain, Notification Domain                 |
| 8 | **CardIssued**           | Выпущена платежная карта                        | Fintech Domain | Patient Domain                                      |
| 9 | **CardBlocked**          | Карта заблокирована                             | Fintech Domain | Patient Domain                                      |

**Домен «Биллинг и расчеты» (Billing Domain)**

| № | Событие              | Описание                                   | Источник       | Подписчики                                            |
|---|----------------------|--------------------------------------------|----------------|-------------------------------------------------------|
| 1 | **InvoiceIssued**    | Выставлен счет на оплату медицинских услуг | Billing Domain | Fintech Domain, Notification Domain, Reporting Domain |
| 2 | **InvoicePaid**      | Счет полностью оплачен                     | Billing Domain | EMR Domain, Reporting Domain                          |
| 3 | **InvoiceOverdue**   | Счет просрочен (не оплачен в срок)         | Billing Domain | Collection Domain, Notification Domain                |
| 4 | **InvoiceCancelled** | Счет аннулирован                           | Billing Domain | Fintech Domain, Reporting Domain                      |
| 5 | **ClaimSubmitted**   | Требование отправлено в страховую компанию | Billing Domain | Reporting Domain                                      |
| 6 | **ClaimSettled**     | Страховая компания оплатила требование     | Billing Domain | Fintech Domain, Reporting Domain                      |
| 7 | **ClaimRejected**    | Страховая компания отклонила требование    | Billing Domain | EMR Domain, Reporting Domain                          |
| 8 | **RefundIssued**     | Произведен возврат средств пациенту        | Billing Domain | Fintech Domain, Reporting Domain                      |
| 9 | **TariffUpdated**    | Обновлены тарифы на медицинские услуги     | Billing Domain | EMR Domain, Reporting Domain                          |

**Домен «ИИ-сервисы» (AI Services Domain)**

| № | Событие                | Описание                                                        | Источник                           | Подписчики                       |
|---|------------------------|-----------------------------------------------------------------|------------------------------------|----------------------------------|
| 1 | **InferenceRequested** | Запрошен анализ медицинских данных ИИ-моделью                   | Diagnostic Domain / Partner Domain | AI Services (внутреннее)         |
| 2 | **InferenceCompleted** | Анализ данных ИИ-моделью завершен, результат готов              | AI Services                        | Diagnostic Domain, EMR Domain    |
| 3 | **ModelDeployed**      | Новая версия модели машинного обучения развернута в production  | AI Services                        | Monitoring Domain, MLOps         |
| 4 | **ModelRetrained**     | Модель переобучена на новых данных                              | AI Services                        | MLOps, Reporting Domain          |
| 5 | **AIServiceConsumed**  | ИИ-сервис использован внешним партнером (для биллинга)          | AI Services                        | Billing Domain, Reporting Domain |
| 6 | **DataDriftDetected**  | Обнаружен дрейф данных (изменение распределения входных данных) | AI Services                        | Monitoring Domain, MLOps         |

**Домен «Персонал» (HR Domain)**

| № | Событие                | Описание                                   | Источник  | Подписчики                        |
|---|------------------------|--------------------------------------------|-----------|-----------------------------------|
| 1 | **EmployeeHired**      | Новый сотрудник принят на работу           | HR Domain | Inventory Domain, Security Domain |
| 2 | **EmployeeTerminated** | Сотрудник уволен                           | HR Domain | Все домены (блокировка доступа)   |
| 3 | **SchedulePublished**  | Опубликовано расписание работы сотрудников | HR Domain | EMR Domain, Reporting Domain      |
| 4 | **ScheduleChanged**    | Расписание работы изменено                 | HR Domain | EMR Domain                        |
| 5 | **RoleAssigned**       | Сотруднику назначена роль/должность        | HR Domain | Security Domain                   |
| 6 | **RoleRevoked**        | У сотрудника отозвана роль                 | HR Domain | Security Domain                   |
| 7 | **VacationRequested**  | Запрошен отпуск                            | HR Domain | Scheduling Domain                 |
| 8 | **VacationApproved**   | Отпуск утвержден                           | HR Domain | Scheduling Domain                 |

**Домен «Инвентаризация» (Inventory Domain)**

| № | Событие                           | Описание                                        | Источник         | Подписчики                              |
|---|-----------------------------------|-------------------------------------------------|------------------|-----------------------------------------|
| 1 | **StockLevelChanged**             | Изменился уровень запасов (приход/расход)       | Inventory Domain | Procurement Domain, Reporting Domain    |
| 2 | **StockLow**                      | Уровень запаса ниже порогового значения         | Inventory Domain | Procurement Domain, Notification Domain |
| 3 | **StockOut**                      | Запас полностью исчерпан                        | Inventory Domain | Procurement Domain, EMR Domain          |
| 4 | **EquipmentInstalled**            | Новое оборудование установлено в клинике        | Inventory Domain | EMR Domain, Reporting Domain            |
| 5 | **EquipmentMaintenanceRequired**  | Оборудование требует технического обслуживания  | Inventory Domain | Maintenance Domain, EMR Domain          |
| 6 | **EquipmentMaintenanceCompleted** | Техническое обслуживание оборудования завершено | Inventory Domain | EMR Domain                              |
| 7 | **EquipmentDecommissioned**       | Оборудование списано/выведено из эксплуатации   | Inventory Domain | Reporting Domain                        |
| 8 | **OrderPlaced**                   | Размещен заказ поставщику                       | Inventory Domain | Procurement Domain, Reporting Domain    |
| 9 | **OrderReceived**                 | Заказ от поставщика получен                     | Inventory Domain | Inventory Domain                        |

**Домен «Отчетность и KPI» (Reporting Domain)**

| № | Событие                  | Описание                                     | Источник         | Подписчики                          |
|---|--------------------------|----------------------------------------------|------------------|-------------------------------------|
| 1 | **ReportGenerated**      | Сформирован отчет по запросу пользователя    | Reporting Domain | Notification Domain, Storage Domain |
| 2 | **ReportScheduled**      | Запланирован регулярный отчет                | Reporting Domain | Scheduler Domain                    |
| 3 | **DashboardShared**      | Дашборд опубликован для других пользователей | Reporting Domain | Collaboration Domain                |
| 4 | **DataRefreshCompleted** | Данные в витрине данных обновлены            | Reporting Domain | Notification Domain                 |
| 5 | **AnomalyDetected**      | Обнаружена аномалия в ключевых показателях   | Reporting Domain | Monitoring Domain, Head Office      |
| 6 | **ExportCompleted**      | Экспорт отчета во внешний формат завершен    | Reporting Domain | Storage Domain                      |

**Домен «Партнерская интеграция» (Partner Domain)**

| № | Событие                    | Описание                                                | Источник       | Подписчики                      |
|---|----------------------------|---------------------------------------------------------|----------------|---------------------------------|
| 1 | **PartnerConnected**       | Новый партнер (фарма/производитель) подключен к системе | Partner Domain | Security Domain, Billing Domain |
| 2 | **PartnerDisconnected**    | Партнер отключен от системы                             | Partner Domain | Security Domain, Billing Domain |
| 3 | **PartnerDataReceived**    | Получены данные от партнера                             | Partner Domain | Data Lake, AI Services          |
| 4 | **PartnerDataSent**        | Данные отправлены партнеру                              | Partner Domain | Audit Domain, Billing Domain    |
| 5 | **PartnerDataFailed**      | Ошибка при получении/отправке данных партнеру           | Partner Domain | Monitoring Domain               |
| 6 | **PartnerContractUpdated** | Обновлены условия сотрудничества с партнером            | Partner Domain | Billing Domain                  |

**Домен «Клиентский сервис» (Customer Service Domain) - опционально**

| № | Событие              | Описание                          | Источник                | Подписчики                            |
|---|----------------------|-----------------------------------|-------------------------|---------------------------------------|
| 1 | **TicketCreated**    | Создано обращение в поддержку     | Customer Service Domain | Notification Domain, Reporting Domain |
| 2 | **TicketResolved**   | Обращение в поддержку решено      | Customer Service Domain | Reporting Domain                      |
| 3 | **FeedbackReceived** | Получен отзыв от пациента/клиента | Customer Service Domain | Quality Domain, Reporting Domain      |

**Домен «Аудит и compliance» (Audit Domain)**

| № | Событие                   | Описание                                                   | Источник     | Подписчики                        |
|---|---------------------------|------------------------------------------------------------|--------------|-----------------------------------|
| 1 | **DataAccessLogged**      | Зафиксирован доступ к чувствительным данным                | Audit Domain | Security Domain, Reporting Domain |
| 2 | **ComplianceCheckPassed** | Проверка соответствия регуляторным требованиям пройдена    | Audit Domain | Reporting Domain                  |
| 3 | **ComplianceCheckFailed** | Проверка соответствия регуляторным требованиям не пройдена | Audit Domain | Security Domain, Head Office      |
| 4 | **AuditReportGenerated**  | Сформирован аудиторский отчет                              | Audit Domain | Reporting Domain                  |

**Домен «Регионы» (Regional Domain) - для географической экспансии**

| № | Событие                    | Описание                                                 | Источник        | Подписчики        |
|---|----------------------------|----------------------------------------------------------|-----------------|-------------------|
| 1 | **RegionConnected**        | Новый регион подключен к общей платформе                 | Regional Domain | Все домены        |
| 2 | **RegionalDataSynced**     | Данные региона синхронизированы с центральной платформой | Regional Domain | Data Lake         |
| 3 | **LocalRegulationUpdated** | Обновлены локальные регуляторные требования              | Regional Domain | Compliance Domain |

## Композитные события (процессы)

**Процесс «Прием пациента»**

```
PatientRegistered → PatientVerified → EncounterStarted → DiagnosisRecorded → PrescriptionIssued → EncounterCompleted → 
InvoiceIssued → PaymentReceived → InvoicePaid
```

**Процесс «ИИ-диагностика»**

```
StudyUploaded → InferenceRequested → InferenceCompleted → AIPredictionAvailable → StudyInterpreted
```

**Процесс «Кредитование»**

```
AccountOpened → LoanIssued → InvoiceIssued (ежемесячно) → PaymentReceived → LoanRepaid
```

**Процесс «Интеграция партнера»**

```
PartnerConnected → PartnerDataReceived → AIServiceConsumed → InvoiceIssued (партнеру)
```
