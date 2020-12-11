-- Задание 1
-- Проанализировать какие запросы могут выполняться наиболее
-- часто в процессе работы приложения и добавить необходимые индексы.
/*
	Из наиболее частых запросов к базе данных социальной сети можно выделить запросы на поиск пользователей, 
поиск обычно производится по Имени и Фамилии, локации пользователя, дате его рождения. Так же часто ищут 
различные медиафайлы, и тут нам нужно будет проиндексировать названия файлов. 
	Такие важные данные как телефоны пользователей, адреса email, и имена владельцев медиафайлов
уже проиндексированы в базе при создании соответствующих таблиц.
	При этом индексы для имени и фамилии и локации пользователей, я считаю разумным сделать составными. Кроме 
того, все эти индексы не будут уникальными.
 */

CREATE INDEX users_last_name_first_name_idx ON users(last_name, first_name);

CREATE INDEX profiles_city_country_idx ON profiles(city, country);

CREATE INDEX profiles_birthday_idx ON profiles(birthday);

CREATE INDEX media_filename_idx on media(filename);

-- Результат:
/*
mysql> USE my_vk;
Reading table information for completion of table and column names
You can turn off this feature to get a quicker startup with -A

Database changed
mysql> CREATE INDEX users_last_name_first_name_idx ON users(last_name, first_name);
Query OK, 0 rows affected (0.17 sec)
Records: 0  Duplicates: 0  Warnings: 0

mysql> CREATE INDEX profiles_city_country_idx ON profiles(city, country);
Query OK, 0 rows affected (0.00 sec)
Records: 0  Duplicates: 0  Warnings: 0

mysql> CREATE INDEX profiles_birthday_idx ON profiles(birthday);
Query OK, 0 rows affected (0.05 sec)
Records: 0  Duplicates: 0  Warnings: 0

mysql> CREATE INDEX media_filename_idx on media(filename);
Query OK, 0 rows affected (0.01 sec)
Records: 0  Duplicates: 0  Warnings: 0

mysql> SHOW INDEX FROM users;
+-------+------------+--------------------------------+--------------+-------------+-----------+-------------+----------+--------+------+------------+---------+---------------+---------+------------+
| Table | Non_unique | Key_name                       | Seq_in_index | Column_name | Collation | Cardinality | Sub_part | Packed | Null | Index_type | Comment | Index_comment | Visible | Expression |
+-------+------------+--------------------------------+--------------+-------------+-----------+-------------+----------+--------+------+------------+---------+---------------+---------+------------+
| users |          0 | PRIMARY                        |            1 | id          | A         |         100 |     NULL |   NULL |      | BTREE      |         |               | YES     | NULL       |
| users |          0 | email                          |            1 | email       | A         |         100 |     NULL |   NULL |      | BTREE      |         |               | YES     | NULL       |
| users |          0 | phone                          |            1 | phone       | A         |         100 |     NULL |   NULL |      | BTREE      |         |               | YES     | NULL       |
| users |          1 | users_last_name_first_name_idx |            1 | last_name   | A         |          89 |     NULL |   NULL |      | BTREE      |         |               | YES     | NULL       |
| users |          1 | users_last_name_first_name_idx |            2 | first_name  | A         |         100 |     NULL |   NULL |      | BTREE      |         |               | YES     | NULL       |
+-------+------------+--------------------------------+--------------+-------------+-----------+-------------+----------+--------+------+------------+---------+---------------+---------+------------+
5 rows in set (0.00 sec)

mysql> SHOW INDEX FROM profiles;
+----------+------------+---------------------------+--------------+-------------+-----------+-------------+----------+--------+------+------------+---------+---------------+---------+------------+
| Table    | Non_unique | Key_name                  | Seq_in_index | Column_name | Collation | Cardinality | Sub_part | Packed | Null | Index_type | Comment | Index_comment | Visible | Expression |
+----------+------------+---------------------------+--------------+-------------+-----------+-------------+----------+--------+------+------------+---------+---------------+---------+------------+
| profiles |          0 | PRIMARY                   |            1 | user_id     | A         |         100 |     NULL |   NULL |      | BTREE      |         |               | YES     | NULL       |
| profiles |          1 | profiles_city_country_idx |            1 | city        | A         |         100 |     NULL |   NULL | YES  | BTREE      |         |               | YES     | NULL       |
| profiles |          1 | profiles_city_country_idx |            2 | country     | A         |         100 |     NULL |   NULL | YES  | BTREE      |         |               | YES     | NULL       |
| profiles |          1 | profiles_birthday_idx     |            1 | birthday    | A         |         100 |     NULL |   NULL | YES  | BTREE      |         |               | YES     | NULL       |
+----------+------------+---------------------------+--------------+-------------+-----------+-------------+----------+--------+------+------------+---------+---------------+---------+------------+
4 rows in set (0.00 sec)

mysql> SHOW INDEX FROM media;
+-------+------------+------------------------+--------------+---------------+-----------+-------------+----------+--------+------+------------+---------+---------------+---------+------------+
| Table | Non_unique | Key_name               | Seq_in_index | Column_name   | Collation | Cardinality | Sub_part | Packed | Null | Index_type | Comment | Index_comment | Visible | Expression |
+-------+------------+------------------------+--------------+---------------+-----------+-------------+----------+--------+------+------------+---------+---------------+---------+------------+
| media |          0 | PRIMARY                |            1 | id            | A         |         300 |     NULL |   NULL |      | BTREE      |         |               | YES     | NULL       |
| media |          1 | media_user_id_fk       |            1 | user_id       | A         |          94 |     NULL |   NULL |      | BTREE      |         |               | YES     | NULL       |
| media |          1 | media_media_type_id_fk |            1 | media_type_id | A         |           3 |     NULL |   NULL |      | BTREE      |         |               | YES     | NULL       |
| media |          1 | media_filename_idx     |            1 | filename      | A         |         272 |     NULL |   NULL |      | BTREE      |         |               | YES     | NULL       |
+-------+------------+------------------------+--------------+---------------+-----------+-------------+----------+--------+------+------------+---------+---------------+---------+------------+
4 rows in set (0.00 sec)
 */

/* Задание 2
Задание на оконные функции
Построить запрос, который будет выводить следующие столбцы:
имя группы;
среднее количество пользователей в группах;
самый молодой пользователь в группе;
самый старший пользователь в группе;
общее количество пользователей в группе;
всего пользователей в системе;
отношение в процентах (общее количество пользователей в группе / всего пользователей в системе) * 100.
*/

-- !Attention!!! Данный запрос даст верный результат только при установленном индексе profiles_birthday_idx из предыдущего задания.!!!

SELECT DISTINCT communities.id,
  communities.name AS community_name,
  COUNT(communities_users.user_id) OVER() / (SELECT COUNT(1) FROM communities)  AS average_users_comm,
  LAST_VALUE(CONCAT(users.first_name, ' ', users.last_name, ' ', birthday)) OVER w AS yongest_user,
  FIRST_VALUE(CONCAT(users.first_name, ' ', users.last_name, ' ', birthday)) OVER w AS oldest_user,
  COUNT(communities_users.user_id) OVER w AS user_in_comm,
  COUNT(users.id) OVER() AS total_users,
  COUNT(communities_users.user_id) OVER w / COUNT(users.id) OVER() * 100 AS "%%"
FROM communities 
  JOIN communities_users
  ON communities.id = communities_users.community_id
  RIGHT JOIN users
  ON communities_users.user_id = users.id
  JOIN profiles
  ON users.id = profiles.user_id 
  WINDOW w AS (PARTITION BY communities_users.community_id);
 
 -- Результат:
 
 /*
mysql> USE my_vk
Reading table information for completion of table and column names
You can turn off this feature to get a quicker startup with -A

Database changed
mysql> SELECT DISTINCT communities.id,
    ->   communities.name AS community_name,
    ->   COUNT(communities_users.user_id) OVER() / (SELECT COUNT(1) FROM communities)  AS average_users_comm,
    ->   LAST_VALUE(CONCAT(users.first_name, ' ', users.last_name, ' ', birthday)) OVER w AS yongest_user,
    ->   FIRST_VALUE(CONCAT(users.first_name, ' ', users.last_name, ' ', birthday)) OVER w AS oldest_user,
    ->   COUNT(communities_users.user_id) OVER w AS user_in_comm,
    ->   COUNT(users.id) OVER() AS total_users,
    ->   COUNT(communities_users.user_id) OVER w / COUNT(users.id) OVER() * 100 AS "%%"
    -> FROM communities
    ->   JOIN communities_users
    ->     ON communities.id = communities_users.community_id
    ->   RIGHT JOIN users
    ->     ON communities_users.user_id = users.id
    ->   JOIN profiles
    ->     ON users.id = profiles.user_id
    ->       WINDOW w AS (PARTITION BY communities_users.community_id);
+------+----------------+--------------------+-------------------------------+------------------------------+--------------+-------------+---------+
| id   | community_name | average_users_comm | yongest_user                  | oldest_user                  | user_in_comm | total_users | %%      |
+------+----------------+--------------------+-------------------------------+------------------------------+--------------+-------------+---------+
|    1 | aspernatur     |             5.0000 | Ella Marvin 2020-04-14        | Daron Kertzmann 1974-03-13   |           10 |         100 | 10.0000 |
|    2 | eligendi       |             5.0000 | Era Rempel 2000-07-17         | Rhea Lemke 1971-06-25        |            3 |         100 |  3.0000 |
|    3 | quis           |             5.0000 | Westley Jakubowski 2000-08-20 | Lenora Kertzmann 1983-06-07  |            3 |         100 |  3.0000 |
|    4 | sit            |             5.0000 | Millie Padberg 1999-01-31     | Jazmyne Aufderhar 1987-01-29 |            2 |         100 |  2.0000 |
|    5 | natus          |             5.0000 | Aimee Reilly 2014-01-31       | Glen Balistreri 1977-06-24   |            3 |         100 |  3.0000 |
|    6 | quisquam       |             5.0000 | Garfield Treutel 2012-12-26   | Logan Tillman 1981-06-26     |            4 |         100 |  4.0000 |
|    7 | voluptates     |             5.0000 | Ernie Hilpert 2009-09-13      | Una Haley 1975-03-31         |            4 |         100 |  4.0000 |
|    8 | earum          |             5.0000 | Dina Kirlin 2012-09-10        | Carissa Streich 1981-07-31   |            7 |         100 |  7.0000 |
|    9 | quaerat        |             5.0000 | Yadira Auer 2015-02-23        | Amari Koepp 1971-02-16       |            6 |         100 |  6.0000 |
|   10 | voluptatem     |             5.0000 | Sonya Kris 2013-05-02         | Alysha Schultz 1972-10-20    |            3 |         100 |  3.0000 |
|   11 | tempora        |             5.0000 | Patsy Hoppe 2019-12-06        | Rickey Bergstrom 1978-11-24  |            8 |         100 |  8.0000 |
|   12 | inventore      |             5.0000 | Richie Abbott 2017-08-20      | Crystal Bechtelar 1979-11-04 |            7 |         100 |  7.0000 |
|   13 | ducimus        |             5.0000 | Jamal Schiller 2013-03-27     | Asha Tremblay 1971-12-13     |            9 |         100 |  9.0000 |
|   14 | laborum        |             5.0000 | Rupert Reichel 2003-05-29     | Thora Hirthe 1970-09-20      |            4 |         100 |  4.0000 |
|   15 | iste           |             5.0000 | Theron Abbott 2013-10-26      | Wilfrid Auer 1986-06-16      |            4 |         100 |  4.0000 |
|   16 | et             |             5.0000 | Linnie Stroman 2000-10-17     | Emil Heller 1975-02-01       |            5 |         100 |  5.0000 |
|   17 | nulla          |             5.0000 | Lucius Kihn 1970-08-12        | Lucius Kihn 1970-08-12       |            1 |         100 |  1.0000 |
|   18 | repudiandae    |             5.0000 | Patience Wiza 2017-04-18      | Austyn Kerluke 1977-03-15    |            4 |         100 |  4.0000 |
|   19 | nobis          |             5.0000 | Izaiah Casper 2005-08-24      | Gladys Maggio 1975-06-05     |            8 |         100 |  8.0000 |
|   20 | commodi        |             5.0000 | Ray Gerhold 2004-06-08        | Estell Heaney 1970-05-16     |            5 |         100 |  5.0000 |
+------+----------------+--------------------+-------------------------------+------------------------------+--------------+-------------+---------+
20 rows in set (0.02 sec)
*/
 
