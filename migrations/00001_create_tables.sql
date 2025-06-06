-- +goose Up
-- SQL in this section is executed when the migration is applied

-- Создание таблицы городов
CREATE TABLE IF NOT EXISTS cities (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) UNIQUE NOT NULL
);

-- Вставка городов
INSERT INTO cities (name) VALUES 
    ('Москва'), ('Санкт-Петербург'), ('Новосибирск'), ('Екатеринбург'), 
    ('Нижний Новгород'), ('Казань'), ('Омск'), ('Самара'), ('Ростов-на-Дону'),
    ('Уфа'), ('Красноярск'), ('Воронеж'), ('Пермь'), ('Волгоград'), ('Краснодар'),
    ('Нью-Йорк'), ('Лондон'), ('Париж'), ('Берлин'), ('Токио');

-- Создание таблицы пользователей
CREATE TABLE IF NOT EXISTS users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    city VARCHAR(50) NOT NULL,
    points INTEGER NOT NULL
);

-- Создание индексов для таблицы users
CREATE INDEX IF NOT EXISTS idx_users_username ON users(username);
CREATE INDEX IF NOT EXISTS idx_users_city ON users(city);
CREATE INDEX IF NOT EXISTS idx_users_points ON users(points DESC);

-- Создание таблицы друзей
CREATE TABLE IF NOT EXISTS friends (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL,
    friend_id INTEGER NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (friend_id) REFERENCES users(id) ON DELETE CASCADE,
    CONSTRAINT unique_friendship UNIQUE (user_id, friend_id),
    CONSTRAINT no_self_friendship CHECK (user_id != friend_id)
);

-- Создание индексов для таблицы friends
CREATE INDEX IF NOT EXISTS idx_friends_user_id ON friends(user_id);
CREATE INDEX IF NOT EXISTS idx_friends_friend_id ON friends(friend_id);

-- +goose Down
-- SQL in this section is executed when the migration is rolled back
DROP TABLE IF EXISTS friends;
DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS cities; 