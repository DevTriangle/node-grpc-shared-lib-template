# Шаблон shared библиотеки для микросервисов NEST.JS с GRPC.

## Структура файлов

- `src/proto` - корневая директория с модулями, `buf.yaml` и `buf.gen.yaml` файлами для генерации typescript классов.
- `src/proto/**` - директория модуля:
  - `filter.proto` - фильтры;
  - `manage.proto` - модели request;
  - `model.proto` - модели entity БД и response;
  - `service.proto` - объявление RPC-сервиса (API-эндпоинтов).
- `src/generated` - сгенерированные интерфейсы и классы для использования в NestJS.

### Генерация файлов

Скрипт создает директорию `src/generated` с классами и интерфейсами для использования в NestJS.

```bash
npm run proto:generate
```

## Примеры файлов

`filter.proto`

```proto
syntax = "proto3";

package order;

import "common/model.proto";

// Сортировка задачи
message OrderSorts {
  optional common.SortOrders id = 1;
}

// Фильтры задачи
message OrderFilters {
  optional string id = 1;
}

// DTO поиска задач
message OrderFilter {
  optional common.FilterOffset offset = 1;
  optional OrderSorts sorts = 2;
  optional OrderFilters filter = 3;
}
```

`manage.proto`

```proto
syntax = "proto3";

package order;

import "google/protobuf/timestamp.proto";

// DTO для задачи (Order)
message OrderRequest {
  optional string id = 1;
  ...
  optional google.protobuf.Timestamp date_start = 9;
  optional google.protobuf.Timestamp date_end = 10;
}
```

`model.proto`

```proto
syntax = "proto3";

package order;

import "category/model.proto";
import "common/model.proto";
import "google/protobuf/struct.proto";
import "google/protobuf/timestamp.proto";
import "order_status/model.proto";
import "order_type/model.proto";
import "task/model.proto";

// Задача
message OrderModel {
  string id = 1;
  ...
  google.protobuf.Timestamp date_start = 11;
  google.protobuf.Timestamp date_end = 12;

  optional task.TaskModel task = 13;
  optional order_type.OrderTypeModel order_type = 14;

  optional category.CategoryModel category = 15;
  optional order_status.OrderStatusModel order_status = 16;

  // Дополнительные данные (any-type)
  optional google.protobuf.Struct additional_data = 17;
}

// Ответ с пагинацией
message ArrayOrderResponse {
  common.PaginationResponse pagination = 1;
  repeated OrderModel data = 2;
}

// Статус
message StatusOrderResponse {
  common.StatusResponse status = 1;
  optional OrderModel data = 2;
}
```

`service.proto`

```proto
syntax = "proto3";

package order;

import "common/model.proto";
import "order/filter.proto";
import "order/manage.proto";
import "order/model.proto";

// Сервис задач (Order)
service OrderService {
  // Создание задач
  rpc Create(OrderRequest) returns (StatusOrderResponse) {}

  // Получение списка задач
  rpc FindAll(OrderFilter) returns (ArrayOrderResponse) {}

  // Получение задачи по ID
  rpc GetOne(common.FindUniqueRequest) returns (OrderModel) {}

  // Изменение задач
  rpc Update(OrderRequest) returns (common.StatusResponse) {}
}
```
