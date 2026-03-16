# Агрегаты целевой событийной архитектуры

**Домен «Пациент» (Patient Domain)**

| Агрегат               | Описание                                                    | Ключевые атрибуты                                                                  | Связанные события                                                     | Ограничения                              |
|-----------------------|-------------------------------------------------------------|------------------------------------------------------------------------------------|-----------------------------------------------------------------------|------------------------------------------|
| **PatientProfile**    | Корневой агрегат, содержащий основную информацию о пациенте | `patientId`, `fullName`, `birthDate`, `gender`, `contacts`, `address`, `status`    | PatientRegistered, PatientVerified, PatientDataUpdated, PatientMerged | Только один активный профиль на пациента |
| **PatientIdentifier** | Коллекция идентификаторов пациента в различных системах     | `identifierId`, `patientId`, `idType` (СНИЛС/полис/паспорт), `idValue`, `verified` | PatientVerified                                                       | Не может существовать без PatientProfile |
| **Consent**           | Согласия пациента на обработку данных и коммуникации        | `consentId`, `patientId`, `consentType`, `grantedAt`, `expiresAt`, `revokedAt`     | ConsentGranted, ConsentRevoked                                        | Хранится история изменений               |

**Домен «Медицинская карта» (EMR Domain)**

| Агрегат          | Описание                                        | Ключевые атрибуты                                                                                        | Связанные события                    | Ограничения                                |
|------------------|-------------------------------------------------|----------------------------------------------------------------------------------------------------------|--------------------------------------|--------------------------------------------|
| **Encounter**    | Корневой агрегат, представляющий прием пациента | `encounterId`, `patientId`, `doctorId`, `startTime`, `endTime`, `status`, `locationId`                   | EncounterStarted, EncounterCompleted | Не может быть изменен после завершения     |
| **Diagnosis**    | Диагноз, поставленный во время приема           | `diagnosisId`, `encounterId`, `icdCode`, `description`, `diagnosisType`, `recordedAt`                    | DiagnosisRecorded                    | Связан с Encounter                         |
| **Prescription** | Рецепт на лекарственное средство                | `prescriptionId`, `encounterId`, `medicationId`, `dosage`, `frequency`, `duration`, `issuedAt`           | PrescriptionIssued                   | Может быть аннулирован, но не удален       |
| **Referral**     | Направление на исследование или консультацию    | `referralId`, `encounterId`, `referralType`, `targetDepartment`, `priority`, `createdAt`                 | ReferralCreated                      | Имеет статус выполнения                    |
| **VitalSigns**   | Показатели жизнедеятельности пациента           | `vitalsId`, `encounterId`, `bloodPressure`, `heartRate`, `temperature`, `oxygenSaturation`, `recordedAt` | VitalsRecorded                       | Опционально, может быть несколько за прием |

**Домен «Медицинские исследования» (Diagnostic Domain)**

| Агрегат        | Описание                                                  | Ключевые атрибуты                                                                       | Связанные события               | Ограничения                                           |
|----------------|-----------------------------------------------------------|-----------------------------------------------------------------------------------------|---------------------------------|-------------------------------------------------------|
| **Study**      | Корневой агрегат, представляющее медицинское исследование | `studyId`, `patientId`, `studyType`, `modality`, `uploadedAt`, `status`, `referralId`   | StudyUploaded, StudyInterpreted | Содержит ссылки на бинарные данные, но не сами данные |
| **Series**     | Серия снимков в рамках исследования                       | `seriesId`, `studyId`, `seriesNumber`, `modality`, `bodyPart`, `imageCount`             | StudyUploaded                   | Часть Study                                           |
| **Report**     | Текстовое заключение врача по результатам исследования    | `reportId`, `studyId`, `radiologistId`, `content`, `createdAt`, `verifiedAt`            | StudyInterpreted                | Может иметь несколько версий                          |
| **Annotation** | Разметка, созданная ИИ-сервисами или врачом               | `annotationId`, `studyId`, `seriesId`, `type`, `coordinates`, `confidence`, `createdBy` | AIPredictionAvailable           | Связана с конкретным исследованием                    |

**Домен «Финтех» (Fintech Domain)**

| Агрегат          | Описание                | Ключевые атрибуты                                                                                                 | Связанные события              | Ограничения                                           |
|------------------|-------------------------|-------------------------------------------------------------------------------------------------------------------|--------------------------------|-------------------------------------------------------|
| **Account**      | Банковский счет клиента | `accountId`, `patientId`, `accountNumber`, `accountType`, `currency`, `balance`, `status`, `openedAt`, `closedAt` | AccountOpened, AccountClosed   | Баланс не может быть отрицательным (кроме овердрафта) |
| **Transaction**  | Финансовая транзакция   | `transactionId`, `accountId`, `amount`, `type`, `status`, `timestamp`, `referenceId`                              | TransactionProcessed           | Неизменяема после проведения                          |
| **Loan**         | Кредитный договор       | `loanId`, `accountId`, `principal`, `interestRate`, `term`, `status`, `issuedAt`, `repaidAt`                      | LoanIssued, LoanRepaid         | Имеет график платежей                                 |
| **PaymentOrder** | Платежное поручение     | `paymentId`, `fromAccount`, `toAccount`, `amount`, `status`, `createdAt`, `executedAt`                            | PaymentReceived, PaymentFailed | Может быть отменен до исполнения                      |
| **Card**         | Платежная карта         | `cardId`, `accountId`, `cardNumber` (token), `expiryDate`, `status`, `issuedAt`                                   | CardIssued, CardBlocked        | Номер карты хранится в токенизированном виде          |

**Домен «Биллинг и расчеты» (Billing Domain)**

| Агрегат               | Описание                        | Ключевые атрибуты                                                                            | Связанные события                                            | Ограничения                         |
|-----------------------|---------------------------------|----------------------------------------------------------------------------------------------|--------------------------------------------------------------|-------------------------------------|
| **Invoice**           | Счет на оплату                  | `invoiceId`, `patientId`, `encounterId`, `amount`, `status`, `issuedAt`, `dueDate`, `paidAt` | InvoiceIssued, InvoicePaid, InvoiceOverdue, InvoiceCancelled | Имеет строки (InvoiceLine)          |
| **InvoiceLine**       | Строка счета (отдельная услуга) | `lineId`, `invoiceId`, `serviceCode`, `description`, `quantity`, `unitPrice`, `total`        | InvoiceIssued                                                | Часть Invoice                       |
| **Claim**             | Требование к страховой компании | `claimId`, `invoiceId`, `insuranceCompany`, `amount`, `status`, `submittedAt`, `settledAt`   | ClaimSubmitted, ClaimSettled, ClaimRejected                  | Привязан к Invoice                  |
| **PaymentAllocation** | Распределение платежа по счетам | `allocationId`, `paymentId`, `invoiceId`, `amount`, `allocatedAt`                            | InvoicePaid                                                  | Связывает платеж и счет             |
| **Tariff**            | Тариф на медицинскую услугу     | `tariffId`, `serviceCode`, `price`, `validFrom`, `validTo`, `insuranceCoverage`              | TariffUpdated                                                | Имеет историю изменений             |
| **Refund**            | Возврат средств                 | `refundId`, `invoiceId`, `amount`, `reason`, `status`, `issuedAt`                            | RefundIssued                                                 | Не может превышать оплаченную сумму |

**Домен «ИИ-сервисы» (AI Services Domain)**

| Агрегат         | Описание                                          | Ключевые атрибуты                                                                            | Связанные события             | Ограничения                  |
|-----------------|---------------------------------------------------|----------------------------------------------------------------------------------------------|-------------------------------|------------------------------|
| **Model**       | Версия модели машинного обучения                  | `modelId`, `name`, `version`, `type`, `status`, `deployedAt`, `accuracy`, `location`         | ModelDeployed, ModelRetrained | Версии иммутабельны          |
| **Inference**   | Результат применения модели к данным              | `inferenceId`, `modelId`, `studyId`, `result`, `confidence`, `processingTime`, `completedAt` | InferenceCompleted            | Неизменяем после создания    |
| **TrainingJob** | Задание на обучение модели                        | `jobId`, `modelId`, `dataset`, `parameters`, `status`, `startedAt`, `completedAt`            | ModelRetrained                | Может быть долгим (часы/дни) |
| **APIKey**      | Ключ доступа для внешних потребителей ИИ-сервисов | `keyId`, `partnerId`, `keyHash`, `permissions`, `createdAt`, `expiresAt`, `lastUsed`         | PartnerConnected              | Хранится только хеш ключа    |

**Домен «Персонал» (HR Domain)**

| Агрегат        | Описание                     | Ключевые атрибуты                                                                                       | Связанные события                   | Ограничения                                |
|----------------|------------------------------|---------------------------------------------------------------------------------------------------------|-------------------------------------|--------------------------------------------|
| **Employee**   | Сотрудник компании           | `employeeId`, `fullName`, `position`, `department`, `contacts`, `hireDate`, `terminationDate`, `status` | EmployeeHired, EmployeeTerminated   | Имеет уникальный табельный номер           |
| **Schedule**   | Расписание работы сотрудника | `scheduleId`, `employeeId`, `date`, `shiftStart`, `shiftEnd`, `locationId`, `status`                    | SchedulePublished, ScheduleChanged  | Не может пересекаться с другим расписанием |
| **Role**       | Роль в системе (набор прав)  | `roleId`, `name`, `permissions` (list), `description`                                                   | RoleAssigned, RoleRevoked           | Стандартные роли предопределены            |
| **Credential** | Учетные данные для входа     | `credentialId`, `employeeId`, `login`, `passwordHash`, `lastLogin`, `requiresReset`                     | EmployeeHired                       | Пароль не хранится в открытом виде         |
| **Vacation**   | Отпуск сотрудника            | `vacationId`, `employeeId`, `startDate`, `endDate`, `status`, `approvedBy`                              | VacationRequested, VacationApproved | Не может пересекаться с больничными        |

**Домен «Инвентаризация» (Inventory Domain)**

| Агрегат               | Описание                          | Ключевые атрибуты                                                                                             | Связанные события                                                         | Ограничения                            |
|-----------------------|-----------------------------------|---------------------------------------------------------------------------------------------------------------|---------------------------------------------------------------------------|----------------------------------------|
| **Equipment**         | Единица медицинского оборудования | `equipmentId`, `name`, `serialNumber`, `model`, `locationId`, `status`, `installationDate`, `lastMaintenance` | EquipmentInstalled, EquipmentMaintenanceRequired, EquipmentDecommissioned | Уникальный серийный номер              |
| **Consumable**        | Расходный материал                | `consumableId`, `name`, `sku`, `quantity`, `unit`, `reorderLevel`, `locationId`                               | StockLevelChanged, StockLow, StockOut                                     | Количество не может быть отрицательным |
| **Supplier**          | Поставщик                         | `supplierId`, `name`, `contacts`, `contractNumber`, `rating`                                                  | OrderPlaced                                                               | Может поставлять несколько позиций     |
| **PurchaseOrder**     | Заказ поставщику                  | `orderId`, `supplierId`, `items`, `totalAmount`, `status`, `orderedAt`, `expectedDelivery`, `receivedAt`      | OrderPlaced, OrderReceived                                                | Имеет статус жизненного цикла          |
| **MaintenanceRecord** | Запись о техническом обслуживании | `recordId`, `equipmentId`, `maintenanceDate`, `type`, `technician`, `notes`, `nextMaintenance`                | EquipmentMaintenanceCompleted                                             | Хранит историю обслуживания            |

**Домен «Отчетность и KPI» (Reporting Domain)**

| Агрегат              | Описание                                | Ключевые атрибуты                                                                           | Связанные события                | Ограничения                               |
|----------------------|-----------------------------------------|---------------------------------------------------------------------------------------------|----------------------------------|-------------------------------------------|
| **ReportDefinition** | Шаблон отчета, созданный пользователем  | `definitionId`, `name`, `ownerId`, `dataSource`, `parameters`, `schedule`, `createdAt`      | ReportScheduled                  | Может быть публичным/приватным            |
| **Report**           | Сгенерированный отчет                   | `reportId`, `definitionId`, `generatedAt`, `format`, `size`, `location`, `expiresAt`        | ReportGenerated, ExportCompleted | Временный, удаляется после expiresAt      |
| **Dashboard**        | Пользовательский дашборд                | `dashboardId`, `name`, `ownerId`, `widgets`, `layout`, `isPublic`, `createdAt`, `updatedAt` | DashboardShared                  | Содержит несколько виджетов               |
| **Dataset**          | Подготовленный набор данных для анализа | `datasetId`, `name`, `source`, `fields`, `rowCount`, `refreshedAt`, `refreshPeriod`         | DataRefreshCompleted             | Может использоваться в нескольких отчетах |
| **Query**            | Сохраненный запрос                      | `queryId`, `name`, `ownerId`, `queryText`, `parameters`, `lastExecuted`                     | ReportGenerated                  | Не хранит результаты, только текст        |

**Домен «Партнерская интеграция» (Partner Domain)**

| Агрегат               | Описание                       | Ключевые атрибуты                                                                            | Связанные события                     | Ограничения                            |
|-----------------------|--------------------------------|----------------------------------------------------------------------------------------------|---------------------------------------|----------------------------------------|
| **Partner**           | Информация о партнере          | `partnerId`, `name`, `type`, `contacts`, `contractId`, `status`, `connectedAt`               | PartnerConnected, PartnerDisconnected | Уникальный идентификатор               |
| **PartnerConnection** | Настройки подключения партнера | `connectionId`, `partnerId`, `protocol`, `endpoint`, `credentials` (encrypted), `options`    | PartnerConnected                      | Учетные данные хранятся зашифрованными |
| **InboundMessage**    | Входящее сообщение от партнера | `messageId`, `partnerId`, `type`, `payload`, `receivedAt`, `status`, `error`                 | PartnerDataReceived                   | Хранится для аудита                    |
| **OutboundMessage**   | Исходящее сообщение партнеру   | `messageId`, `partnerId`, `type`, `payload`, `sentAt`, `status`, `deliveryAttempts`, `error` | PartnerDataSent                       | Механизм повторных попыток при ошибке  |
| **PartnerContract**   | Договор с партнером            | `contractId`, `partnerId`, `terms`, `startDate`, `endDate`, `pricing`, `limits`              | PartnerContractUpdated                | Определяет условия биллинга            |

**Домен «Клиентский сервис» (Customer Service Domain)**

| Агрегат           | Описание                | Ключевые атрибуты                                                                                              | Связанные события             | Ограничения                   |
|-------------------|-------------------------|----------------------------------------------------------------------------------------------------------------|-------------------------------|-------------------------------|
| **Ticket**        | Обращение в поддержку   | `ticketId`, `patientId`, `category`, `priority`, `subject`, `description`, `status`, `createdAt`, `resolvedAt` | TicketCreated, TicketResolved | Имеет историю статусов        |
| **TicketComment** | Комментарий к обращению | `commentId`, `ticketId`, `authorId`, `content`, `createdAt`                                                    | TicketUpdated                 | Неизменяем после создания     |
| **Feedback**      | Отзыв от пациента       | `feedbackId`, `patientId`, `encounterId`, `rating`, `comment`, `submittedAt`                                   | FeedbackReceived              | Анонимизируется для аналитики |

**Домен «Аудит и compliance» (Audit Domain)**

| Агрегат             | Описание                          | Ключевые атрибуты                                                                             | Связанные события                            | Ограничения                     |
|---------------------|-----------------------------------|-----------------------------------------------------------------------------------------------|----------------------------------------------|---------------------------------|
| **AccessLog**       | Запись о доступе к данным         | `logId`, `userId`, `resourceType`, `resourceId`, `action`, `timestamp`, `ipAddress`, `result` | DataAccessLogged                             | Неизменяема, хранится долго     |
| **ComplianceCheck** | Проверка соответствия требованиям | `checkId`, `checkType`, `status`, `checkedAt`, `checkedBy`, `details`, `violations`           | ComplianceCheckPassed, ComplianceCheckFailed | Хранит детали нарушений         |
| **AuditReport**     | Аудиторский отчет                 | `reportId`, `period`, `generatedAt`, `findings`, `recommendations`, `location`                | AuditReportGenerated                         | Может быть запрошен регулятором |

**Домен «Регионы» (Regional Domain)**

| Агрегат              | Описание                          | Ключевые атрибуты                                                                      | Связанные события      | Ограничения                          |
|----------------------|-----------------------------------|----------------------------------------------------------------------------------------|------------------------|--------------------------------------|
| **Region**           | Географический регион присутствия | `regionId`, `name`, `country`, `timezone`, `currency`, `status`, `connectedAt`         | RegionConnected        | Учитывает локальное законодательство |
| **RegionalDataSync** | Синхронизация данных с регионом   | `syncId`, `regionId`, `dataType`, `startedAt`, `completedAt`, `recordsCount`, `status` | RegionalDataSynced     | Обеспечивает консистентность         |
| **LocalRegulation**  | Локальные регуляторные требования | `regulationId`, `regionId`, `type`, `requirements`, `effectiveFrom`, `effectiveTo`     | LocalRegulationUpdated | Влияет на compliance                 |

## Связи между агрегатами (ключевые ассоциации)

| Агрегат        | Связан с          | Тип связи   | Описание                                                           |
|----------------|-------------------|-------------|--------------------------------------------------------------------|
| PatientProfile | Encounter         | One-to-Many | Один пациент может иметь много приемов                             |
| Encounter      | Diagnosis         | One-to-Many | Один прием может содержать несколько диагнозов                     |
| Encounter      | Prescription      | One-to-Many | Один прием может содержать несколько рецептов                      |
| Encounter      | Invoice           | One-to-One  | Один прием → один счет (обычно)                                    |
| Study          | Inference         | One-to-Many | Одно исследование может быть проанализировано несколькими моделями |
| Account        | Transaction       | One-to-Many | Один счет → много транзакций                                       |
| Invoice        | InvoiceLine       | One-to-Many | Один счет → много строк                                            |
| Partner        | PartnerConnection | One-to-One  | Один партнер → одно подключение                                    |
| Employee       | Schedule          | One-to-Many | Один сотрудник → много записей в расписании                        |
| Equipment      | MaintenanceRecord | One-to-Many | Одно оборудование → много записей об обслуживании                  |
