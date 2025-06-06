-- Запрос 1: Получение информации о рейтинге конкретного пользователя
-- Принимает параметр username из командной строки (например: -v username="user123")

WITH 
-- Основная информация о пользователе
user_info AS (
    SELECT 
        id,
        username,
        city,
        points
    FROM 
        users
    WHERE 
        username = 'user123' -- Фиксированное значение или используйте psql переменную
),
-- Общий рейтинг всех пользователей
overall_ranks AS (
    SELECT 
        id,
        RANK() OVER (ORDER BY points DESC) AS overall_rank
    FROM 
        users
),
-- Рейтинг пользователей по городам
city_ranks AS (
    SELECT 
        id,
        RANK() OVER (PARTITION BY city ORDER BY points DESC) AS city_rank
    FROM 
        users
),
-- Список друзей пользователя
user_friends AS (
    SELECT 
        friend_id
    FROM 
        friends
    WHERE 
        user_id = (SELECT id FROM user_info)
),
-- Рейтинг среди друзей
friend_ranks AS (
    SELECT 
        u.id,
        RANK() OVER (ORDER BY u.points DESC) AS friend_rank
    FROM 
        users u
    JOIN 
        user_friends uf ON u.id = uf.friend_id
)
-- Финальный запрос, объединяющий все вычисления
SELECT 
    ui.username,
    ui.points,
    ui.city,
    o_ranks.overall_rank AS "Место в общем рейтинге",
    c_ranks.city_rank AS "Место в рейтинге города",
    COALESCE(f_ranks.friend_rank, 0) AS "Место среди друзей",
    (SELECT COUNT(*) FROM users) AS "Всего пользователей",
    (SELECT COUNT(*) FROM users WHERE city = ui.city) AS "Пользователей в городе",
    (SELECT COUNT(*) FROM user_friends) AS "Количество друзей"
FROM 
    user_info ui
JOIN 
    overall_ranks o_ranks ON ui.id = o_ranks.id
JOIN 
    city_ranks c_ranks ON ui.id = c_ranks.id
LEFT JOIN 
    friend_ranks f_ranks ON ui.id = f_ranks.id; 