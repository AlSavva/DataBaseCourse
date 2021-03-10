-- 4. Подсчитать общее количество лайков десяти самым молодым пользователям 
-- (сколько лайков получили 10 самых молодых пользователей).

-- Не нашёл решения без создания временной таблицы:
-- Создаём временную таблицу с результатами запроса:

CREATE TEMPORARY TABLE tmp
 SELECT 
   COUNT(*) AS total_likes,
   target_id,
   (SELECT CONCAT(first_name, ' ', last_name) FROM users WHERE users.id = target_id) AS name,  
   (SELECT FLOOR(TO_DAYS(NOW()) - TO_DAYS(birthday)) / 365.25 FROM profiles WHERE user_id = target_id) AS age
 FROM 
   likes 
 WHERE 
   target_type_id = 2 
 GROUP BY 
   target_id
 ORDER BY 
   age
 LIMIT 10;

SELECT * FROM tmp;

-- Результат выполнения:

/*
 mysql> CREATE TEMPORARY TABLE tmp
    ->  SELECT
    ->    COUNT(*) AS total_likes,
    ->    target_id,
    ->    (SELECT CONCAT(first_name, ' ', last_name) FROM users WHERE users.id = target_id) AS name,
    ->    (SELECT FLOOR(TO_DAYS(NOW()) - TO_DAYS(birthday)) / 365.25 FROM profiles WHERE user_id = target_id) AS age
    ->  FROM
    ->    likes
    ->  WHERE
    ->    target_type_id = 2
    ->  GROUP BY
    ->    target_id
    ->  ORDER BY
    ->    age
    ->  LIMIT 10;
Query OK, 10 rows affected (0.01 sec)
Records: 10  Duplicates: 0  Warnings: 0

mysql>
mysql> SELECT * FROM tmp;
+-------------+-----------+-------------------+---------+
| total_likes | target_id | name              | age     |
+-------------+-----------+-------------------+---------+
|           4 |        73 | Patsy Hoppe       |  0.9719 |
|           3 |        64 | Junius Runolfsson |  6.4476 |
|           1 |        15 | Beatrice Skiles   |  6.4750 |
|           1 |        61 | Rico Moen         |  8.6434 |
|           1 |        32 | Addison Bernier   |  9.4976 |
|           1 |        53 | Clovis Reichert   | 11.0445 |
|           1 |        33 | Ernie Hilpert     | 11.2005 |
|           2 |        97 | Winifred Larson   | 15.8275 |
|           1 |        94 | Rupert Reichel    | 17.4949 |
|           1 |        12 | Megane Simonis    | 19.6441 |
+-------------+-----------+-------------------+---------+
10 rows in set (0.00 sec)
 */

SELECT 
  SUM(total_likes) AS sum_top_10 
FROM
  tmp;
 
 -- -- Результат выполнения:
 
 /*
  mysql> SELECT
    ->   SUM(total_likes) AS sum_top_10
    -> FROM
    ->   tmp;
+------------+
| sum_top_10 |
+------------+
|         16 |
+------------+
1 row in set (0.00 sec)
  */

 -- Удаляем временную таблицу:
 
DROP TABLE tmp;
