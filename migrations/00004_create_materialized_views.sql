-- +goose Up
-- SQL in this section is executed when the migration is applied

-- Материализованное представление с рейтингами пользователей
CREATE MATERIALIZED VIEW user_rankings AS
SELECT 
    id,
    username,
    city,
    points,
    RANK() OVER (ORDER BY points DESC) AS overall_rank
FROM 
    users;

-- Индексы для материализованного представления
CREATE UNIQUE INDEX idx_user_rankings_id ON user_rankings(id);
CREATE INDEX idx_user_rankings_username ON user_rankings(username);
CREATE INDEX idx_user_rankings_rank ON user_rankings(overall_rank);

-- Материализованное представление с рейтингами по городам
CREATE MATERIALIZED VIEW city_rankings AS
SELECT 
    id,
    username,
    city,
    points,
    RANK() OVER (PARTITION BY city ORDER BY points DESC) AS city_rank
FROM 
    users;

-- Индексы для материализованного представления городов
CREATE UNIQUE INDEX idx_city_rankings_id ON city_rankings(id);
CREATE INDEX idx_city_rankings_city ON city_rankings(city);

-- +goose Down
-- SQL in this section is executed when the migration is rolled back
DROP MATERIALIZED VIEW IF EXISTS city_rankings;
DROP MATERIALIZED VIEW IF EXISTS user_rankings; 