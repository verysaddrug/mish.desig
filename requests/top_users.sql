-- Запрос 2: Получение топ-100 пользователей по общему рейтингу

WITH ranked_users AS (
    SELECT 
        id,
        username,
        city,
        points,
        RANK() OVER (ORDER BY points DESC) AS rank
    FROM 
        users
)
SELECT 
    rank,
    username,
    city,
    points
FROM 
    ranked_users
WHERE 
    rank <= 100
ORDER BY 
    rank; 