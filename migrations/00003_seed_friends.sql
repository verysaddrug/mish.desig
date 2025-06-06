-- +goose Up
-- SQL in this section is executed when the migration is applied

-- Функция для оптимизированного заполнения таблицы friends
DO $$
DECLARE
    batch_size INTEGER := 100000; -- Размер пакета для вставки
    max_user_id INTEGER;
    i INTEGER;
    batch_start INTEGER;
    num_friends INTEGER;
    friend_id INTEGER;
    current_user_id INTEGER;
BEGIN
    -- Получаем максимальный ID пользователя
    SELECT MAX(id) FROM users INTO max_user_id;
    
    -- Для каждого пользователя создаем от 1 до 20 друзей
    FOR i IN 0..max_user_id/batch_size LOOP
        batch_start := i * batch_size + 1;
        RAISE NOTICE 'Processing batch starting at %', batch_start;
        
        -- Для каждого пользователя в пакете
        FOR current_user_id IN batch_start..LEAST(batch_start + batch_size - 1, max_user_id) LOOP
            -- Определяем случайное количество друзей от 1 до 20
            num_friends := 1 + (random() * 19)::integer;
            
            -- Добавляем указанное количество друзей
            FOR j IN 1..num_friends LOOP
                -- Выбираем случайного друга, исключая самого пользователя
                LOOP
                    friend_id := 1 + (random() * (max_user_id - 1))::integer;
                    EXIT WHEN friend_id != current_user_id;
                END LOOP;
                
                -- Вставляем запись о дружбе, игнорируя дубликаты
                BEGIN
                    INSERT INTO friends (user_id, friend_id)
                    VALUES (current_user_id, friend_id);
                EXCEPTION WHEN unique_violation THEN
                    -- Игнорируем дубликаты
                END;
            END LOOP;
        END LOOP;
        
        -- Делаем коммит после каждого пакета
        COMMIT;
    END LOOP;
END $$;

-- +goose Down
-- SQL in this section is executed when the migration is rolled back
TRUNCATE friends; 