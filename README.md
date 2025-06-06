# Система рейтинга пользователей

Проект для работы с пользователями, их городами и друзьями. Позволяет получать информацию о рейтинге пользователей.

## Что умеет система

- Хранит данные о пользователях (имя, город, очки)
- Хранит связи между друзьями
- Рассчитывает рейтинги пользователей
- Выполняет быстрые запросы по рейтингам

## Структура проекта

- `docker-compose.yaml` - настройка Docker
- `migrations/` - миграции для создания и изменения базы данных
- `requests/` - SQL-запросы для получения данных
- `tasks/` - описание заданий

## Как запустить

1. Запустить базу данных
2. Выполнить SQL-файлы для создания таблиц:
   - 00001_create_tables.sql
   - 00002_seed_users.sql
   - 00003_seed_friends.sql
   - 00004_create_materialized_views.sql
   - 00005_partitioning.sql

## Как пользоваться

### Просмотр списка городов
Выполнить запрос из файла `/requests/list_cities.sql`

### Получение рейтинга пользователя
Выполнить запрос из файла `/requests/user_rating_param.sql` с параметром username

### Получение топ-100 пользователей
Выполнить запрос из файла `/requests/top_users.sql`

### Получение топ-100 пользователей в Москве
Выполнить запрос из файла `/requests/top_city_users.sql`

### Получение топ-100 друзей пользователя
Выполнить запрос из файла `/requests/top_friends.sql`

### Ускорение запросов
Выполнить SQL-запросы:
- `/migrations/refresh_materialized_views.sql`
