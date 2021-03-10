-- 5. Найти 10 пользователей, которые проявляют наименьшую активность в использовании социальной сети

/*За критерий активности будем принимать отношение количества действий совершённых пользователем, с
момента создания аккаунта к сроку жизни аккаунта(т.е. количество активных действий в день).
За активные действия примем:
- публикация поста - posts_published, 
- отправка сообщения - message_sent,
- членство в сообществе - community_join,
- размещение медиа-контента - media_shared, 
- отправка медиа в сообщении - media_attached(выделил отдельно, как действие свойственное активным пользователям),
- количество поставленных лайков - total_liked
- в друзьях у... - in_friends,
- дружит с ... - friends_with.
По двум последним столбцам текущий статус дружбы не учитывался, т.к. любое из действий связанных дружбой-можно считать проявлением
активности в сети.
*/

-- Для демонстрации результата воспользуемся промежуточной таблицей:

CREATE TEMPORARY TABLE tbl
SELECT 
	id,
	CONCAT(first_name, ' ', last_name) AS full_name,
	FLOOR(TO_DAYS(NOW()) - TO_DAYS(created_at)) AS account_age,
	IFNULL((SELECT COUNT(*) FROM communities_users GROUP BY user_id HAVING communities_users.user_id = users.id), 0) AS community_join,
	IFNULL((SELECT COUNT(*) FROM messages GROUP BY from_user_id HAVING from_user_id = users.id), 0) AS message_sent,
	IFNULL((SELECT COUNT(*) FROM media GROUP BY user_id HAVING media.user_id = users.id), 0) AS media_shared,
	IFNULL((SELECT COUNT(*) FROM posts GROUP BY user_id HAVING posts.user_id = users.id), 0) AS posts_published,
	IFNULL((SELECT COUNT(media_id) FROM posts GROUP BY user_id HAVING posts.user_id = users.id), 0) AS media_attached,
	IFNULL((SELECT COUNT(*) FROM likes GROUP BY user_id HAVING likes.user_id = users.id), 0) AS total_liked,
	IFNULL((SELECT COUNT(*) FROM friendship GROUP BY user_id HAVING friendship.user_id = users.id), 0) AS in_friends,
	IFNULL((SELECT COUNT(*) FROM friendship GROUP BY friend_id HAVING friendship.friend_id = users.id), 0) AS friends_with,
	(SELECT (community_join + message_sent + media_shared + posts_published + media_attached + total_liked + in_friends + friends_with)) AS total,
	(SELECT total / account_age) AS activity_rate
FROM
  users;
 
 -- Результат:
/* 
 mysql> CREATE TEMPORARY TABLE tbl
    -> SELECT
    -> id,
    -> CONCAT(first_name, ' ', last_name) AS full_name,
    -> FLOOR(TO_DAYS(NOW()) - TO_DAYS(created_at)) AS account_age,
    -> IFNULL((SELECT COUNT(*) FROM communities_users GROUP BY user_id HAVING communities_users.user_id = users.id), 0) AS community_join,
    -> IFNULL((SELECT COUNT(*) FROM messages GROUP BY from_user_id HAVING from_user_id = users.id), 0) AS message_sent,
    -> IFNULL((SELECT COUNT(*) FROM media GROUP BY user_id HAVING media.user_id = users.id), 0) AS media_shared,
    -> IFNULL((SELECT COUNT(*) FROM posts GROUP BY user_id HAVING posts.user_id = users.id), 0) AS posts_published,
    -> IFNULL((SELECT COUNT(media_id) FROM posts GROUP BY user_id HAVING posts.user_id = users.id), 0) AS media_attached,
    -> IFNULL((SELECT COUNT(*) FROM likes GROUP BY user_id HAVING likes.user_id = users.id), 0) AS total_liked,
    -> IFNULL((SELECT COUNT(*) FROM friendship GROUP BY user_id HAVING friendship.user_id = users.id), 0) AS in_friends,
    -> IFNULL((SELECT COUNT(*) FROM friendship GROUP BY friend_id HAVING friendship.friend_id = users.id), 0) AS friends_with,
    -> (SELECT (community_join + message_sent + media_shared + posts_published + media_attached + total_liked + in_friends + friends_with)) AS total,
    -> (SELECT total / account_age) AS activity_rate
    -> FROM
    ->   users;
Query OK, 100 rows affected, 100 warnings (0.30 sec)
Records: 100  Duplicates: 0  Warnings: 100

mysql> SELECT * FROM tbl LIMIT 5;
+----+------------------+-------------+----------------+--------------+--------------+-----------------+----------------+-------------+------------+--------------+-------+---------------+
| id | full_name        | account_age | community_join | message_sent | media_shared | posts_published | media_attached | total_liked | in_friends | friends_with | total | activity_rate |
+----+------------------+-------------+----------------+--------------+--------------+-----------------+----------------+-------------+------------+--------------+-------+---------------+
|  1 | Gregg Stiedemann |        2197 |              1 |            2 |            1 |               3 |              0 |           5 |          1 |            0 |    13 |        0.0059 |
|  2 | Izaiah Casper    |         551 |              1 |            8 |            4 |               5 |              1 |           4 |          1 |            0 |    24 |        0.0436 |
|  3 | Tessie Labadie   |        1718 |              1 |            4 |            2 |               4 |              2 |           7 |          0 |            0 |    20 |        0.0116 |
|  4 | Murphy Hills     |        1808 |              1 |            3 |            0 |               3 |              0 |           2 |          0 |            0 |     9 |        0.0050 |
|  5 | Vincent Schumm   |        1463 |              1 |            4 |            1 |               2 |              0 |           3 |          1 |            0 |    12 |        0.0082 |
+----+------------------+-------------+----------------+--------------+--------------+-----------------+----------------+-------------+------------+--------------+-------+---------------+
5 rows in set (0.00 sec)
*/
 
 -- 10 пользователей с наименьшим количеством действий в сети:
 
SELECT
  id,
  full_name,
  total,
  activity_rate
FROM
  tbl
ORDER BY 
  total
LIMIT 10;

-- Результат:
/*
 mysql> SELECT
    ->   id,
    ->   full_name,
    ->   total,
    ->   activity_rate
    -> FROM
    ->   tbl
    -> ORDER BY
    ->   total
    -> LIMIT 10;
+----+-----------------+-------+---------------+
| id | full_name       | total | activity_rate |
+----+-----------------+-------+---------------+
| 12 | Megane Simonis  |     6 |        0.0355 |
|  7 | May Ferry       |     6 |        0.0024 |
| 58 | Erwin Hauck     |     7 |        0.0024 |
| 53 | Clovis Reichert |     8 |        0.0148 |
| 99 | Jayme Ratke     |     8 |        0.0034 |
| 11 | Alivia Simonis  |     8 |        0.0101 |
| 15 | Beatrice Skiles |     9 |        0.0062 |
|  4 | Murphy Hills    |     9 |        0.0050 |
| 87 | Amalia Haley    |     9 |        0.0040 |
| 44 | Yadira Auer     |     9 |        0.0073 |
+----+-----------------+-------+---------------+
10 rows in set (0.00 sec)
 */

-- 10 пользователей с наименьшим относительным количеством действий в сети в день:

SELECT
  id,
  full_name,
  total,
  activity_rate
FROM
  tbl
ORDER BY
  activity_rate 
LIMIT 10;

-- Результат:
/*
mysql> SELECT
    ->   id,
    ->   full_name,
    ->   total,
    ->   activity_rate
    -> FROM
    ->   tbl
    -> ORDER BY
    ->   activity_rate
    -> LIMIT 10;
+-----+------------------+-------+---------------+
| id  | full_name        | total | activity_rate |
+-----+------------------+-------+---------------+
|  58 | Erwin Hauck      |     7 |        0.0024 |
|   7 | May Ferry        |     6 |        0.0024 |
|  50 | Dina Kirlin      |     9 |        0.0026 |
|  85 | Aimee Reilly     |    10 |        0.0027 |
|  40 | Lenora Kertzmann |    10 |        0.0029 |
|  32 | Addison Bernier  |    10 |        0.0030 |
|  79 | Jordy Stracke    |    11 |        0.0033 |
| 100 | Dena O'Keefe     |    11 |        0.0033 |
|   9 | Wayne Schuster   |    10 |        0.0033 |
|  70 | Sonya Kris       |    10 |        0.0033 |
+-----+------------------+-------+---------------+
10 rows in set (0.00 sec)
*/
  
