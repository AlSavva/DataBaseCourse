-- Переписать запросы, заданые к ДЗ урока 6, с использованием JOIN

-- 1. Определить кто больше поставил лайков (всего) - мужчины или женщины?

-- Вариант из ДЗ 6:
/*
 SELECT 
  COUNT(*),
  (SELECT gender
   FROM profiles 
   WHERE profiles.user_id = likes.user_id
   ) AS gender
FROM
  likes
GROUP BY
  gender;
  
-->
+----------+--------+
| COUNT(*) | gender |
+----------+--------+
|      125 | M      |
|      175 | F      |
+----------+--------+

 */

SELECT pr.gender,
  COUNT(*)
  FROM profiles AS pr
    JOIN likes
      ON pr.user_id = likes.user_id
     GROUP BY
       pr.gender;

-- Результат:
      
/*
mysql> SELECT pr.gender,
    ->   COUNT(*)
    ->   FROM profiles AS pr
    ->     JOIN likes
    ->       ON pr.user_id = likes.user_id
    ->      GROUP BY
    ->        pr.gender;
+--------+----------+
| gender | COUNT(*) |
+--------+----------+
| M      |      125 |
| F      |      175 |
+--------+----------+
2 rows in set (0.00 sec)

 */


-- 4. Подсчитать общее количество лайков десяти самым молодым пользователям (сколько лайков получили 10 самых молодых пользователей).

 -- Вариант из ДЗ 6:
 
/*
 SELECT SUM(likes_total) FROM  
  (SELECT 
    (SELECT COUNT(*) FROM likes WHERE target_id = profiles.user_id AND target_type_id = 2) AS likes_total  
    FROM profiles 
    ORDER BY birthday 
    DESC LIMIT 10) AS user_likes;
    
 -->
 +----------+
| COUNT(*) |
+----------+
|        8 |
+----------+
1 row in set (0.00 sec)
 */
 
SELECT 
  COUNT(*)
FROM likes AS lk
  JOIN (SELECT user_id FROM profiles
        ORDER BY birthday DESC LIMIT 10) AS pr
    ON lk.target_id = pr.user_id
    AND lk.target_type_id = 2;
     
-- Результат:
/*
mysql> SELECT
    ->   COUNT(*)
    -> FROM likes AS lk
    ->   JOIN (SELECT user_id FROM profiles
    ->         ORDER BY birthday DESC LIMIT 10) AS pr
    ->     ON lk.target_id = pr.user_id
    ->     AND lk.target_type_id = 2;
+----------+
| COUNT(*) |
+----------+
|        8 |
+----------+
1 row in set (0.00 sec)

 */


-- 5. Найти 10 пользователей, которые проявляют наименьшую активность в использовании социальной сети

-- Вариант из ДЗ 6:

/*
mysql> SELECT
    ->   CONCAT(first_name, ' ', last_name) AS user,
    -> (SELECT COUNT(*) FROM likes WHERE likes.user_id = users.id) +
    -> (SELECT COUNT(*) FROM media WHERE media.user_id = users.id) +
    -> (SELECT COUNT(*) FROM messages WHERE messages.from_user_id = users.id) AS overall_activity
    ->   FROM users
    ->   ORDER BY overall_activity
    ->   LIMIT 10;
+-----------------+------------------+
| user            | overall_activity |
+-----------------+------------------+
| Clovis Reichert |                4 |
| Patience Wiza   |                4 |
| May Ferry       |                4 |
| Arnaldo Becker  |                4 |
| Amalia Haley    |                4 |
| Addison Bernier |                5 |
| Megane Simonis  |                5 |
| Murphy Hills    |                5 |
| Dina Kirlin     |                5 |
| Alivia Simonis  |                5 |
+-----------------+------------------+
10 rows in set (0.08 sec)
 */

SELECT 
  CONCAT(u.first_name, ' ', u.last_name) AS user,
  (COUNT(DISTINCT lk.id) + 
  COUNT(DISTINCT media.id) + 
  COUNT(DISTINCT messages.id)) AS overall_activity
   FROM users AS u
   LEFT JOIN likes AS lk
     ON u.id = lk.user_id
   LEFT JOIN media 
     ON media.user_id = u.id
   LEFT JOIN messages 
     ON messages.from_user_id = u.id
   GROUP BY user
   ORDER BY overall_activity
   LIMIT 10;
  
-- Результат:

/*
mysql> SELECT
    ->   CONCAT(u.first_name, ' ', u.last_name) AS user,
    ->   (COUNT(DISTINCT lk.id) +
    ->   COUNT(DISTINCT media.id) +
    ->   COUNT(DISTINCT messages.id)) AS overall_activity
    ->    FROM users AS u
    ->    LEFT JOIN likes AS lk
    ->      ON u.id = lk.user_id
    ->    LEFT JOIN media
    ->      ON media.user_id = u.id
    ->    LEFT JOIN messages
    ->      ON messages.from_user_id = u.id
    ->    GROUP BY user
    ->    ORDER BY overall_activity
    ->    LIMIT 10;
+-----------------+------------------+
| user            | overall_activity |
+-----------------+------------------+
| Clovis Reichert |                4 |
| Amalia Haley    |                4 |
| May Ferry       |                4 |
| Patience Wiza   |                4 |
| Arnaldo Becker  |                4 |
| Addison Bernier |                5 |
| Dina Kirlin     |                5 |
| Megane Simonis  |                5 |
| Alivia Simonis  |                5 |
| Murphy Hills    |                5 |
+-----------------+------------------+
10 rows in set (0.00 sec)

*/