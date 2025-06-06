-- Оптимизированная версия запроса рейтинга пользователя
-- Использует материализованные представления для ускорения

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
        username = 'user123' -- Замените на нужного пользователя
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
-- Рейтинг среди друзей (вычисляется только для друзей, а не для всех пользователей)
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
    ur.overall_rank AS "Место в общем рейтинге",
    cr.city_rank AS "Место в рейтинге города",
    COALESCE(fr.friend_rank, 0) AS "Место среди друзей",
    (SELECT COUNT(*) FROM users) AS "Всего пользователей",
    (SELECT COUNT(*) FROM users WHERE city = ui.city) AS "Пользователей в городе",
    (SELECT COUNT(*) FROM user_friends) AS "Количество друзей"
FROM 
    user_info ui
JOIN 
    user_rankings ur ON ui.id = ur.id
JOIN 
    city_rankings cr ON ui.id = cr.id
LEFT JOIN 
    friend_ranks fr ON ui.id = fr.id; 