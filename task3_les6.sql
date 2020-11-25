-- 3. Определить кто больше поставил лайков (всего) - мужчины или женщины?

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
 
-- Результат выполнения:

/*
 mysql> SELECT
    ->   COUNT(*),
    ->   (SELECT gender
    ->    FROM profiles
    ->    WHERE profiles.user_id = likes.user_id
    ->    ) AS gender
    -> FROM
    ->   likes
    -> GROUP BY
    ->   gender;
+----------+--------+
| COUNT(*) | gender |
+----------+--------+
|      125 | M      |
|      175 | F      |
+----------+--------+
2 rows in set (0.00 sec)
*/
 
 -- Ответ: Больше лайков поставили женщины.