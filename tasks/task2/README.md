# Задача 2: Запросы на получение данных

## Что нужно сделать

1. Написать запрос, который показывает всех пользователей по убыванию очков
2. Добавить столбец с местом пользователя в общем рейтинге
3. Написать запрос, который для конкретного пользователя показывает:
   - Имя пользователя
   - Количество очков
   - Место в общем рейтинге
   - Место среди пользователей его города
   - Место среди его друзей

## Как решено

### Получение пользователей с рейтингом

Создан запрос, который сортирует пользователей по очкам и показывает их рейтинг:

```sql
WITH ranked_users AS (
    SELECT 
        id, username, city, points,
        RANK() OVER (ORDER BY points DESC) AS overall_rank
    FROM users
)
SELECT username, city, points, overall_rank
FROM ranked_users
ORDER BY overall_rank
LIMIT 100;
```

### Получение рейтинга конкретного пользователя

Создан запрос `user_rating.sql`, который показывает всю информацию о рейтинге пользователя:

```sql
-- Основная часть запроса (сокращено)
SELECT 
    ui.username, ui.points, ui.city,
    o_ranks.overall_rank AS "Место в общем рейтинге",
    c_ranks.city_rank AS "Место в рейтинге города",
    fr.friend_rank AS "Место среди друзей"
FROM user_info ui
JOIN overall_ranks o_ranks ON ui.id = o_ranks.id
JOIN city_ranks c_ranks ON ui.id = c_ranks.id
LEFT JOIN friend_ranks fr ON ui.id = fr.id;
```

## Как запустить

Выполнить SQL-запрос из файла `/requests/user_rating.sql` с параметром username 