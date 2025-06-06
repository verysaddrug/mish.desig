# Задача 4: Дополнительная логика

## Что нужно сделать

1. Написать запрос для получения топ-100 пользователей по общему рейтингу
2. Написать запрос для получения топ-100 пользователей в указанном городе
3. Написать запрос для получения топ-100 друзей указанного пользователя

## Как решено

### Топ-100 пользователей по рейтингу

Запрос в файле `requests/top_users.sql`:

```sql
WITH ranked_users AS (
    SELECT 
        id, username, city, points,
        RANK() OVER (ORDER BY points DESC) AS rank
    FROM users
)
SELECT rank, username, city, points
FROM ranked_users
WHERE rank <= 100
ORDER BY rank;
```

### Топ-100 пользователей в Москве

Запрос в файле `requests/top_city_users.sql`:

```sql
WITH city_ranked_users AS (
    SELECT 
        id, username, city, points,
        RANK() OVER (PARTITION BY city ORDER BY points DESC) AS city_rank
    FROM users
    WHERE city = 'Москва'
)
SELECT city_rank, username, points
FROM city_ranked_users
WHERE city_rank <= 100
ORDER BY city_rank;
```

### Топ-100 друзей пользователя

Запрос в файле `requests/top_friends.sql`:

```sql
WITH 
user_id AS (
    SELECT id FROM users WHERE username = 'user123'
),
friends_list AS (
    SELECT friend_id
    FROM friends
    WHERE user_id = (SELECT id FROM user_id)
),
ranked_friends AS (
    SELECT 
        u.id, u.username, u.city, u.points,
        RANK() OVER (ORDER BY u.points DESC) AS friend_rank
    FROM users u
    JOIN friends_list fl ON u.id = fl.friend_id
)
SELECT friend_rank, username, city, points
FROM ranked_friends
WHERE friend_rank <= 100
ORDER BY friend_rank;
```

## Как запустить

Выполнить следующие SQL-запросы:
- `/requests/top_users.sql` - Топ-100 пользователей
- `/requests/top_city_users.sql` - Топ-100 пользователей в Москве
- `/requests/top_friends.sql` - Топ-100 друзей пользователя

Эти запросы можно параметризовать для возможности изменения города, имени пользователя или количества возвращаемых записей. 