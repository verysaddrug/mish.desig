# Задача 1: Подготовка базы данных

## Что нужно сделать

1. Создать таблицу пользователей (users)
2. Создать таблицу друзей (friends)
3. Заполнить таблицу users 10 миллионами тестовых записей:
   - username: уникальное имя пользователя
   - city: случайный город из списка
   - points: случайное число от 0 до 1 000 000
4. Заполнить таблицу friends: для каждого пользователя создать от 1 до 20 друзей

## Как решено

Созданы три миграции:
1. `00001_create_tables.sql` - создает таблицы cities, users и friends
2. `00002_seed_users.sql` - заполняет таблицу users
3. `00003_seed_friends.sql` - заполняет таблицу friends

## Структура таблиц

### Таблица cities
```sql
CREATE TABLE cities (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) UNIQUE NOT NULL
);
```

### Таблица users
```sql
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    city VARCHAR(50) NOT NULL,
    points INTEGER NOT NULL
);
```

### Таблица friends
```sql
CREATE TABLE friends (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL,
    friend_id INTEGER NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (friend_id) REFERENCES users(id),
    CONSTRAINT unique_friendship UNIQUE (user_id, friend_id),
    CONSTRAINT no_self_friendship CHECK (user_id != friend_id)
);
```

## Как запустить

Выполнить SQL-скрипты в следующем порядке:
1. 00001_create_tables.sql
2. 00002_seed_users.sql
3. 00003_seed_friends.sql 