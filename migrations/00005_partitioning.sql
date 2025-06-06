-- +goose Up
-- SQL in this section is executed when the migration is applied

-- Примечание: в реальном проекте это было бы сделано в начальной схеме,
-- а не как отдельная миграция, так как миграция такого типа потребует
-- пересоздания таблицы и копирования данных

-- Создание партиционированной таблицы users_partitioned
CREATE TABLE users_partitioned (
    id SERIAL,
    username VARCHAR(50) NOT NULL,
    city VARCHAR(50) NOT NULL,
    points INTEGER NOT NULL,
    PRIMARY KEY (id, city)
) PARTITION BY LIST (city);

-- Создание партиций для каждого города
CREATE TABLE users_moscow PARTITION OF users_partitioned FOR VALUES IN ('Москва');
CREATE TABLE users_spb PARTITION OF users_partitioned FOR VALUES IN ('Санкт-Петербург');
CREATE TABLE users_novosibirsk PARTITION OF users_partitioned FOR VALUES IN ('Новосибирск');
CREATE TABLE users_other PARTITION OF users_partitioned DEFAULT;

-- Индексы для партиционированной таблицы
CREATE INDEX idx_users_part_username ON users_partitioned(username);
CREATE INDEX idx_users_part_points ON users_partitioned(points DESC);

-- Примечание: В реальном сценарии здесь был бы код для
-- копирования данных из старой таблицы в новую

-- +goose Down
-- SQL in this section is executed when the migration is rolled back
DROP TABLE IF EXISTS users_partitioned CASCADE; 