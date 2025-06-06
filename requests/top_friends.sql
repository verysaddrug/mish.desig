-- Запрос 4: Получение топ-100 друзей пользователя user123

WITH 
-- Получаем ID пользователя
user_id AS (
    SELECT id FROM users WHERE username = 'user123'
),
-- Получаем список друзей пользователя
friends_list AS (
    SELECT 
        friend_id
    FROM 
        friends
    WHERE 
        user_id = (SELECT id FROM user_id)
),
-- Ранжируем друзей по очкам
ranked_friends AS (
    SELECT 
        u.id,
        u.username,
        u.city,
        u.points,
        RANK() OVER (ORDER BY u.points DESC) AS friend_rank
    FROM 
        users u
    JOIN 
        friends_list fl ON u.id = fl.friend_id
)
-- Финальный запрос для получения топ-100 друзей
SELECT 
    friend_rank,
    username,
    city,
    points
FROM 
    ranked_friends
WHERE 
    friend_rank <= 100
ORDER BY 
    friend_rank; 