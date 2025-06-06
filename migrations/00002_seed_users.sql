-- +goose Up
-- SQL in this section is executed when the migration is applied

-- Функция для генерации случайных имен пользователей
CREATE OR REPLACE FUNCTION generate_username(integer) RETURNS TEXT AS $$
BEGIN
    RETURN 'user' || $1;
END;
$$ LANGUAGE plpgsql;

-- Функция для оптимизированного заполнения таблицы users
DO $$
DECLARE
    batch_size INTEGER := 100000; -- Размер пакета для вставки
    total_users INTEGER := 10000000; -- Общее количество пользователей (10 миллионов)
    i INTEGER;
    batch_start INTEGER;
    random_cities TEXT[];
BEGIN
    -- Получаем массив городов для быстрого доступа
    SELECT array_agg(name) FROM cities INTO random_cities;
    
    -- Заполняем пакетами по batch_size пользователей
    FOR i IN 0..total_users/batch_size-1 LOOP
        batch_start := i * batch_size + 1;
        RAISE NOTICE 'Inserting batch starting at %', batch_start;
        
        -- Вставка пакета пользователей
        INSERT INTO users (username, city, points)
        SELECT 
            generate_username(j), -- Уникальное имя пользователя
            random_cities[1 + (random() * (array_length(random_cities, 1) - 1))::integer], -- Случайный город
            (random() * 1000000)::integer -- Случайное количество очков от 0 до 1000000
        FROM generate_series(batch_start, batch_start + batch_size - 1) j;
        
        -- Делаем коммит после каждого пакета для снижения нагрузки на память
        COMMIT;
    END LOOP;
END $$;

-- Удаляем временную функцию
DROP FUNCTION IF EXISTS generate_username(integer);

-- +goose Down
-- SQL in this section is executed when the migration is rolled back
TRUNCATE users CASCADE; 