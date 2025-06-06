-- Скрипт для обновления материализованных представлений
-- Можно выполнять по расписанию для поддержания актуальности данных,
-- но тоже может аффектить

-- Обновление общего рейтинга
REFRESH MATERIALIZED VIEW CONCURRENTLY user_rankings;

-- Обновление рейтинга по городам
REFRESH MATERIALIZED VIEW CONCURRENTLY city_rankings;

SELECT 'Материализованные представления успешно обновлены' AS result; 