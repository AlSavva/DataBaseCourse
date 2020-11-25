-- 2. Создать все необходимые внешние ключи и диаграмму отношений.

USE my_vk;

-- Для таблицы профилей

DESC profiles;

-- Добавляем внешние ключи
ALTER TABLE profiles
  ADD CONSTRAINT profiles_user_id_fk 
    FOREIGN KEY (user_id) REFERENCES users(id)
      ON DELETE CASCADE;
     
-- ALTER TABLE profiles DROP FOREIGN KEY profiles_user_id_fk;
     
-- Для таблицы сообщений
     
DESC messages;

-- Добавляем внешние ключи
ALTER TABLE messages
  ADD CONSTRAINT messages_from_user_id_fk 
    FOREIGN KEY (from_user_id) REFERENCES users(id),
  ADD CONSTRAINT messages_to_user_id_fk 
    FOREIGN KEY (to_user_id) REFERENCES users(id);

-- ALTER TABLE messages DROP FOREIGN KEY messages_from_user_id_fk;
-- ALTER TABLE messages DROP FOREIGN KEY messages_to_user_id_fk;

ALTER TABLE messages
  ADD CONSTRAINT messages_media_id_fk 
    FOREIGN KEY (media_id) REFERENCES media(id);
   
-- ALTER TABLE messages DROP FOREIGN KEY messages_media_id_fk;
   
   
-- Для таблицы лайков

ALTER TABLE likes
  ADD CONSTRAINT likes_iser_id_fk
    FOREIGN KEY (user_id) REFERENCES users(id);
   
-- ALTER TABLE likes DROP FOREIGN KEY likes_iser_id_fk;
   
ALTER TABLE likes
  ADD CONSTRAINT likes_target_type_fk
    FOREIGN KEY likes(target_type_id) REFERENCES target_types(id);
   
-- ALTER TABLE likes DROP FOREIGN KEY likes_target_type_fk;

-- Для таблицы медиа

ALTER TABLE media 
  ADD CONSTRAINT media_user_id_fk 
    FOREIGN KEY (user_id) REFERENCES users(id),
  ADD CONSTRAINT media_media_type_id_fk 
    FOREIGN KEY (media_type_id) REFERENCES media_types(id);
   
-- Для таблицы отношений пользователь-сообщество

ALTER TABLE communities_users 
  ADD CONSTRAINT communities_users_users_id_fk 
    FOREIGN KEY (user_id) REFERENCES users(id),
  ADD CONSTRAINT communities_users_community_id_fk 
    FOREIGN KEY (community_id) REFERENCES communities(id);
   
-- ALTER TABLE communities_users DROP FOREIGN KEY communities_users_users_id_fk;

-- Для таблицы дружбы

ALTER TABLE friendship 
  ADD CONSTRAINT friendship_users_id_fk 
    FOREIGN KEY (user_id) REFERENCES users(id),
  ADD CONSTRAINT friendship_friend_id_fk 
    FOREIGN KEY (friend_id) REFERENCES users(id),
  ADD CONSTRAINT friendship_friendship_statuses_id_fk 
    FOREIGN KEY (status_id) REFERENCES friendship_statuses(id);
   
 -- Для таблицы постов

ALTER TABLE posts 
  ADD CONSTRAINT posts_users_id_fk 
    FOREIGN KEY (user_id) REFERENCES users(id),
  ADD CONSTRAINT posts_communities_id_fk 
    FOREIGN KEY (community_id) REFERENCES communities(id),
  ADD CONSTRAINT posts_media_id_fk 
    FOREIGN KEY (media_id) REFERENCES media(id);
 
   
  
  

