-- Запрос 3: Получение топ-100 пользователей в городе "Москва"

WITH city_ranked_users AS (
    SELECT 
        id,
        username,
        city,
        points,
        RANK() OVER (PARTITION BY city ORDER BY points DESC) AS city_rank
    FROM 
        users
    WHERE 
        city = 'Москва'
)
SELECT 
    city_rank,
    username,
    points
FROM 
    city_ranked_users
WHERE 
    city_rank <= 100
ORDER BY 
    city_rank; 