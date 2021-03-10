-- 1. В базе данных shop и sample присутствуют одни и те же таблицы, учебной базы данных.
-- Переместите запись id = 1 из таблицы shop.users в таблицу sample.users. Используйте
-- транзакции.

USE sample;

/*
mysql> USE sample;
Reading table information for completion of table and column names
You can turn off this feature to get a quicker startup with -A

Database changed

 */

SELECT * FROM users;

/*
 mysql> SELECT * FROM users;
Empty set (0.00 sec)

mysql> DESC users;
+-------------+-----------------+------+-----+-------------------+-----------------------------------------------+
| Field       | Type            | Null | Key | Default           | Extra                                         |
+-------------+-----------------+------+-----+-------------------+-----------------------------------------------+
| id          | bigint unsigned | NO   | PRI | NULL              | auto_increment                                |
| name        | varchar(255)    | YES  |     | NULL              |                                               |
| birthday_at | date            | YES  |     | NULL              |                                               |
| created_at  | datetime        | YES  |     | CURRENT_TIMESTAMP | DEFAULT_GENERATED                             |
| updated_at  | datetime        | YES  |     | CURRENT_TIMESTAMP | DEFAULT_GENERATED on update CURRENT_TIMESTAMP |
+-------------+-----------------+------+-----+-------------------+-----------------------------------------------+
5 rows in set (0.00 sec)
 */

SELECT * FROM shop.users;

/*
 mysql> SELECT * FROM shop.users;
+----+--------------------+-------------+---------------------+---------------------+
| id | name               | birthday_at | created_at          | updated_at          |
+----+--------------------+-------------+---------------------+---------------------+
|  1 | Геннадий           | 1990-10-05  | 2020-12-01 11:31:04 | 2020-12-01 11:31:04 |
|  2 | Наталья            | 1984-11-12  | 2020-12-01 11:31:04 | 2020-12-01 11:31:04 |
|  3 | Александр          | 1985-05-20  | 2020-12-01 11:31:04 | 2020-12-01 11:31:04 |
|  4 | Сергей             | 1988-02-14  | 2020-12-01 11:31:04 | 2020-12-01 11:31:04 |
|  5 | Иван               | 1998-01-12  | 2020-12-01 11:31:04 | 2020-12-01 11:31:04 |
|  6 | Мария              | 1992-08-29  | 2020-12-01 11:31:04 | 2020-12-01 11:31:04 |
+----+--------------------+-------------+---------------------+---------------------+
6 rows in set (0.00 sec)
 */

START TRANSACTION;

INSERT INTO sample.users SELECT * FROM shop.users WHERE users.id = 1;

COMMIT;

SELECT * FROM users;

/*
mysql> START TRANSACTION;
Query OK, 0 rows affected (0.00 sec)

mysql> INSERT INTO users
    ->   SELECT * FROM shop.users
    ->   WHERE users.id = 1;
Query OK, 1 row affected (0.00 sec)
Records: 1  Duplicates: 0  Warnings: 0

mysql> COMMIT;
Query OK, 0 rows affected (0.00 sec)

mysql> SELECT * FROM users;
+----+------------------+-------------+---------------------+---------------------+
| id | name             | birthday_at | created_at          | updated_at          |
+----+------------------+-------------+---------------------+---------------------+
|  1 | Геннадий         | 1990-10-05  | 2020-12-01 11:31:04 | 2020-12-01 11:31:04 |
+----+------------------+-------------+---------------------+---------------------+
1 row in set (0.00 sec)
 */

-- 2. Создайте представление, которое выводит название name товарной позиции из таблицы
-- products и соответствующее название каталога name из таблицы catalogs.

USE shop;

SELECT * FROM products;

SELECT * FROM catalogs;

CREATE VIEW names
AS SELECT products.name AS prod_name,
     catalogs.name AS cat_mame
   FROM products
   JOIN catalogs
   ON products.catalog_id = catalogs.id;

SELECT * FROM names;

-- Результат:

/*
mysql> USE shop;
Reading table information for completion of table and column names
You can turn off this feature to get a quicker startup with -A

Database changed
mysql> SELECT * FROM products;
+----+-------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------+----------+------------+---------------------+---------------------+
| id | name                    | description                                                                                                                                         | price    | catalog_id | created_at          | updated_at          |
+----+-------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------+----------+------------+---------------------+---------------------+
|  1 | Intel Core i3-8100      | Процессор для настольных персональных компьютеров, основанных на платформе Intel.                                                                   |  7890.00 |          1 | 2020-12-01 11:32:43 | 2020-12-01 11:32:43 |
|  2 | Intel Core i5-7400      | Процессор для настольных персональных компьютеров, основанных на платформе Intel.                                                                   | 12700.00 |          1 | 2020-12-01 11:32:43 | 2020-12-01 11:32:43 |
|  3 | AMD FX-8320E            | Процессор для настольных персональных компьютеров, основанных на платформе AMD.                                                                     |  4780.00 |          1 | 2020-12-01 11:32:43 | 2020-12-01 11:32:43 |
|  4 | AMD FX-8320             | Процессор для настольных персональных компьютеров, основанных на платформе AMD.                                                                     |  7120.00 |          1 | 2020-12-01 11:32:43 | 2020-12-01 11:32:43 |
|  5 | ASUS ROG MAXIMUS X HERO | Материнская плата ASUS ROG MAXIMUS X HERO, Z370, Socket 1151-V2, DDR4, ATX                                                                          | 19310.00 |          2 | 2020-12-01 11:32:43 | 2020-12-01 11:32:43 |
|  6 | Gigabyte H310M S2H      | Материнская плата Gigabyte H310M S2H, H310, Socket 1151-V2, DDR4, mATX                                                                              |  4790.00 |          2 | 2020-12-01 11:32:43 | 2020-12-01 11:32:43 |
|  7 | MSI B250M GAMING PRO    | Материнская плата MSI B250M GAMING PRO, B250, Socket 1151, DDR4, mATX                                                                               |  5060.00 |          2 | 2020-12-01 11:32:43 | 2020-12-01 11:32:43 |
+----+-------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------+----------+------------+---------------------+---------------------+
7 rows in set (0.00 sec)

mysql> SELECT * FROM catalogs;
+----+-------------------------------------+
| id | name                                |
+----+-------------------------------------+
|  1 | Процессоры                          |
|  2 | Материнские платы                   |
|  3 | Видеокарты                          |
|  4 | Жесткие диски                       |
|  5 | Оперативная память                  |
+----+-------------------------------------+
5 rows in set (0.00 sec)

mysql> CREATE VIEW names
    -> AS SELECT products.name AS prod_name,
    ->      catalogs.name AS cat_mame
    ->    FROM products
    ->    JOIN catalogs
    ->    ON products.catalog_id = catalogs.id;CREATE VIEW names
Query OK, 0 rows affected (0.01 sec)

    -> AS SELECT products.name AS prod_name,
    ->      catalogs.name AS cat_mame
    ->    FROM products
    ->    JOIN catalogs
    ->    JOIN catalogs
[1]+  Остановлен    mysql
alsavva@ubuntu3:~$ mysql
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 14
Server version: 8.0.22-0ubuntu0.20.04.3 (Ubuntu)

Copyright (c) 2000, 2020, Oracle and/or its affiliates. All rights reserved.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql>
mysql> USE shop;
Reading table information for completion of table and column names
You can turn off this feature to get a quicker startup with -A

Database changed
mysql> SELECT * FROM products;
+----+-------------------------+-------------------------------------------------------------------------------------+----------+------------+---------------------+---------------------+
| id | name                    | description                                                                         | price    | catalog_id | created_at          | updated_at          |
+----+-------------------------+-------------------------------------------------------------------------------------+----------+------------+---------------------+---------------------+
|  1 | Intel Core i3-8100      | Процессор для настольных персональных компьютеров, основанных на платформе Intel.   |  7890.00 |          1 | 2020-12-01 11:32:43 | 2020-12-01 11:32:43 |
|  2 | Intel Core i5-7400      | Процессор для настольных персональных компьютеров, основанных на платформе Intel.   | 12700.00 |          1 | 2020-12-01 11:32:43 | 2020-12-01 11:32:43 |
|  3 | AMD FX-8320E            | Процессор для настольных персональных компьютеров, основанных на платформе AMD.     |  4780.00 |          1 | 2020-12-01 11:32:43 | 2020-12-01 11:32:43 |
|  4 | AMD FX-8320             | Процессор для настольных персональных компьютеров, основанных на платформе AMD.     |  7120.00 |          1 | 2020-12-01 11:32:43 | 2020-12-01 11:32:43 |
|  5 | ASUS ROG MAXIMUS X HERO | Материнская плата ASUS ROG MAXIMUS X HERO, Z370, Socket 1151-V2, DDR4, ATX          | 19310.00 |          2 | 2020-12-01 11:32:43 | 2020-12-01 11:32:43 |
|  6 | Gigabyte H310M S2H      | Материнская плата Gigabyte H310M S2H, H310, Socket 1151-V2, DDR4, mATX              |  4790.00 |          2 | 2020-12-01 11:32:43 | 2020-12-01 11:32:43 |
|  7 | MSI B250M GAMING PRO    | Материнская плата MSI B250M GAMING PRO, B250, Socket 1151, DDR4, mATX               |  5060.00 |          2 | 2020-12-01 11:32:43 | 2020-12-01 11:32:43 |
+----+-------------------------+-------------------------------------------------------------------------------------+----------+------------+---------------------+---------------------+
7 rows in set (0.00 sec)

mysql> SELECT * FROM catalogs;
+----+-------------------------------------+
| id | name                                |
+----+-------------------------------------+
|  1 | Процессоры                          |
|  2 | Материнские платы                   |
|  3 | Видеокарты                          |
|  4 | Жесткие диски                       |
|  5 | Оперативная память                  |
+----+-------------------------------------+
5 rows in set (0.00 sec)

mysql> CREATE VIEW names
    ->   AS SELECT products.name AS prod_name,
    ->     catalogs.name AS cat_name
    ->   FROM products
    ->   JOIN catalogs
    ->     ON products.catalog_id = catalogs.id;
Query OK, 0 rows affected (0.01 sec)

mysql> SELECT * FROM names;
+-------------------------+-----------------------------------+
| prod_name               | cat_name                          |
+-------------------------+-----------------------------------+
| Intel Core i3-8100      | Процессоры                        |
| Intel Core i5-7400      | Процессоры                        |
| AMD FX-8320E            | Процессоры                        |
| AMD FX-8320             | Процессоры                        |
| ASUS ROG MAXIMUS X HERO | Материнские платы                 |
| Gigabyte H310M S2H      | Материнские платы                 |
| MSI B250M GAMING PRO    | Материнские платы                 |
+-------------------------+-----------------------------------+
7 rows in set (0.00 sec)

 */

-- 3 (по желанию) Пусть имеется таблица с календарным полем created_at. В ней размещены разряженые 
-- календарные записи за август 2018 года '2018-08-01', '2016-08-04', '2018-08-16' и 2018-08-17. 
-- Составьте запрос, который выводит полный список дат за август, выставляя в соседнем поле значение 1, 
-- если дата присутствует в исходном таблице и 0, если она отсутствует

CREATE TABLE dates (
  id SERIAL PRIMARY KEY,
  created_at DATE
);

INSERT INTO dates VALUES
  (NULL, '2018-08-01'),
  (NULL, '2018-08-04'),
  (NULL, '2018-08-16'),
  (NULL, '2018-08-17');
 
SELECT * FROM dates;

CREATE TEMPORARY TABLE num (
  i INT
 );

INSERT INTO num VALUES 
  (0), (1), (2), (3), (4), (5), (6), (7), (8), (9), (10),
  (11), (12), (13), (14), (15), (16), (17), (18), (19), (20),
  (21), (22), (23), (24), (25), (26), (27), (28), (29), (30);

SELECT * FROM num;

SELECT
  DATE(DATE('2018-08-31') - INTERVAL n.i DAY) AS day,
  NOT ISNULL(d.created_at) AS order_exist
FROM
	num AS n
LEFT JOIN
  dates AS d
ON
  DATE(DATE('2018-08-31') - INTERVAL n.i DAY) = d.created_at
ORDER BY
  day;
 
 -- Результат:
 
 /*
 mysql> CREATE TABLE dates (
    ->   id SERIAL PRIMARY KEY,
    ->   created_at DATE
    -> );
Query OK, 0 rows affected (0.01 sec)

mysql> INSERT INTO dates VALUES
    ->   (NULL, '2018-08-01'),
    ->   (NULL, '2018-08-04'),
    ->   (NULL, '2018-08-16'),
    ->   (NULL, '2018-08-17');
Query OK, 4 rows affected (0.00 sec)
Records: 4  Duplicates: 0  Warnings: 0

mysql> SELECT * FROM dates;
+----+------------+
| id | created_at |
+----+------------+
|  1 | 2018-08-01 |
|  2 | 2018-08-04 |
|  3 | 2018-08-16 |
|  4 | 2018-08-17 |
+----+------------+
4 rows in set (0.00 sec)

mysql> CREATE TEMPORARY TABLE num (
    ->   i INT
    -> );
Query OK, 0 rows affected (0.00 sec)

mysql> INSERT INTO num VALUES
    ->   (0), (1), (2), (3), (4), (5), (6), (7), (8), (9), (10),
    ->   (11), (12), (13), (14), (15), (16), (17), (18), (19), (20),
    ->   (21), (22), (23), (24), (25), (26), (27), (28), (29), (30);
Query OK, 31 rows affected (0.00 sec)
Records: 31  Duplicates: 0  Warnings: 0

mysql> SELECT * FROM num;
+------+
| i    |
+------+
|    0 |
|    1 |
|    2 |
|    3 |
|    4 |
|    5 |
|    6 |
|    7 |
|    8 |
|    9 |
|   10 |
|   11 |
|   12 |
|   13 |
|   14 |
|   15 |
|   16 |
|   17 |
|   18 |
|   19 |
|   20 |
|   21 |
|   22 |
|   23 |
|   24 |
|   25 |
|   26 |
|   27 |
|   28 |
|   29 |
|   30 |
+------+
31 rows in set (0.00 sec)

mysql> SELECT
    ->   DATE(DATE('2018-08-31') - INTERVAL n.i DAY) AS day,
    ->   NOT ISNULL(d.created_at) AS order_exist
    -> FROM
    ->   num AS n
    -> LEFT JOIN dates AS d
    ->   ON DATE(DATE('2018-08-31') - INTERVAL n.i DAY) = d.created_at
    -> ORDER BY
    ->   day;
+------------+-------------+
| day        | order_exist |
+------------+-------------+
| 2018-08-01 |           1 |
| 2018-08-02 |           0 |
| 2018-08-03 |           0 |
| 2018-08-04 |           1 |
| 2018-08-05 |           0 |
| 2018-08-06 |           0 |
| 2018-08-07 |           0 |
| 2018-08-08 |           0 |
| 2018-08-09 |           0 |
| 2018-08-10 |           0 |
| 2018-08-11 |           0 |
| 2018-08-12 |           0 |
| 2018-08-13 |           0 |
| 2018-08-14 |           0 |
| 2018-08-15 |           0 |
| 2018-08-16 |           1 |
| 2018-08-17 |           1 |
| 2018-08-18 |           0 |
| 2018-08-19 |           0 |
| 2018-08-20 |           0 |
| 2018-08-21 |           0 |
| 2018-08-22 |           0 |
| 2018-08-23 |           0 |
| 2018-08-24 |           0 |
| 2018-08-25 |           0 |
| 2018-08-26 |           0 |
| 2018-08-27 |           0 |
| 2018-08-28 |           0 |
| 2018-08-29 |           0 |
| 2018-08-30 |           0 |
| 2018-08-31 |           0 |
+------------+-------------+
31 rows in set (0.00 sec)
  */
  
-- 4.(по желанию) Пусть имеется любая таблица с календарным полем created_at. 
-- Создайте запрос, который удаляет устаревшие записи из таблицы, оставляя
-- только 5 самых свежих записей.

DROP TABLE IF EXISTS dates;

CREATE TABLE dates (
  id SERIAL PRIMARY KEY,
  created_at DATE
);

INSERT INTO dates VALUES
    (NULL, '2018-08-02'),
	(NULL, '2018-08-01'),
	(NULL, '2018-08-04'),
	(NULL, '2018-08-12'),
	(NULL, '2018-08-14'),
	(NULL, '2018-08-17'),
	(NULL, '2018-08-23'),
	(NULL, '2018-08-27'),
	(NULL, '2018-08-29'),
	(NULL, '2018-08-31');

SELECT * FROM dates;

DELETE
  dates
FROM
  dates
JOIN
 (SELECT
    created_at
  FROM
    dates
  ORDER BY
    created_at DESC
  LIMIT 5, 1) AS del_dates
ON
  dates.created_at <= del_dates.created_at;
 
SELECT * FROM dates;

-- Результат:

/*
 mysql> DROP TABLE IF EXISTS dates;
Query OK, 0 rows affected (0.01 sec)

mysql> CREATE TABLE dates (
    ->   id SERIAL PRIMARY KEY,
    ->   created_at DATE
    -> );
Query OK, 0 rows affected (0.01 sec)

mysql> INSERT INTO dates VALUES
    ->   (NULL, '2018-08-02'),
    ->   (NULL, '2018-08-01'),
    ->   (NULL, '2018-08-04'),
    ->   (NULL, '2018-08-14'),
    ->   (NULL, '2018-08-12'),
    ->   (NULL, '2018-08-17'),
    ->   (NULL, '2018-08-23'),
    ->   (NULL, '2018-08-27'),
    ->   (NULL, '2018-08-29'),
    ->   (NULL, '2018-08-31');
Query OK, 10 rows affected (0.00 sec)
Records: 10  Duplicates: 0  Warnings: 0

mysql> SELECT * FROM dates;
+----+------------+
| id | created_at |
+----+------------+
|  1 | 2018-08-02 |
|  2 | 2018-08-01 |
|  3 | 2018-08-04 |
|  4 | 2018-08-14 |
|  5 | 2018-08-12 |
|  6 | 2018-08-17 |
|  7 | 2018-08-23 |
|  8 | 2018-08-27 |
|  9 | 2018-08-29 |
| 10 | 2018-08-31 |
+----+------------+
10 rows in set (0.00 sec)

mysql> DELETE
    ->   dates
    -> FROM
    ->   dates
    -> JOIN
    ->  (SELECT
    ->     created_at
    ->   FROM
    ->     dates
    ->   ORDER BY
    ->     created_at DESC
    ->   LIMIT 5, 1) AS del_dates
    -> ON
    ->   dates.created_at <= del_dates.created_at;
Query OK, 5 rows affected (0.00 sec)

mysql> SELECT * FROM dates;
+----+------------+
| id | created_at |
+----+------------+
|  6 | 2018-08-17 |
|  7 | 2018-08-23 |
|  8 | 2018-08-27 |
|  9 | 2018-08-29 |
| 10 | 2018-08-31 |
+----+------------+
5 rows in set (0.00 sec)
 */

-- Раздел “Хранимые процедуры и функции, триггеры" 

-- 1. Создайте хранимую функцию hello(), которая будет возвращать приветствие, в зависимости от
-- текущего времени суток. С 6:00 до 12:00 функция должна возвращать фразу "Доброе утро", с
-- 12:00 до 18:00 функция должна возвращать фразу "Добрый день", с 18:00 до 00:00 — "Добрый
-- вечер", с 00:00 до 6:00 — "Доброй ночи".


DELIMITER //
CREATE FUNCTION hello()
RETURNS TINYTEXT NO SQL
  BEGIN
	  CASE 
		  WHEN CURTIME() BETWEEN '06:00:00' AND '12:00:00' THEN RETURN 'Доброе утро';
		  WHEN CURTIME() BETWEEN '12:00:00' AND '18:00:00' THEN RETURN 'Добрый день';
		  WHEN CURTIME() BETWEEN '18:00:00' AND '00:00:00' THEN RETURN 'Добрый вечер';
		  ELSE
			  RETURN 'Доброй ночи';
	  END CASE;
  END //
DELIMITER ;

SELECT CURTIME(), hello();

DROP FUNCTION IF EXISTS hello;

-- Результат:

/*
mysql> DELIMITER //
mysql> CREATE FUNCTION hello()
    -> RETURNS TINYTEXT NO SQL
    ->   BEGIN
    ->       CASE
    ->          WHEN CURTIME() BETWEEN '06:00:00' AND '12:00:00' THEN RETURN 'Доброе утро';
    ->          WHEN CURTIME() BETWEEN '12:00:00' AND '18:00:00' THEN RETURN 'Добрый день';
    ->          WHEN CURTIME() BETWEEN '18:00:00' AND '00:00:00' THEN RETURN 'Добрый вечер';
    ->       ELSE
    ->          RETURN 'Доброй ночи';
    ->       END CASE;
    ->    END //
Query OK, 0 rows affected (0.00 sec)

mysql> DELIMITER ;
mysql> SELECT CURTIME(), hello();
+-----------+-----------------------+
| CURTIME() | hello()               |
+-----------+-----------------------+
| 15:13:13  | Добрый день           |
+-----------+-----------------------+
1 row in set (0.00 sec)
*/

-- 2. В таблице products есть два текстовых поля: name с названием товара и description с его
-- описанием. Допустимо присутствие обоих полей или одно из них. Ситуация, когда оба поля
-- принимают неопределенное значение NULL неприемлема. Используя триггеры, добейтесь
-- того, чтобы одно из этих полей или оба поля были заполнены. При попытке присвоить полям
-- NULL-значение необходимо отменить операцию.

DELIMITER //

CREATE TRIGGER validate_name_description_insert BEFORE INSERT ON products
FOR EACH ROW BEGIN
  IF NEW.name IS NULL AND NEW.description IS NULL THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Both name and description are NULL';
  END IF;
END//

INSERT INTO products
  (name, description, price, catalog_id)
VALUES
  (NULL, NULL, 9360.00, 2)//

INSERT INTO products
  (name, description, price, catalog_id)
VALUES
  ('ASUS PRIME Z370-P', 'HDMI, SATA3, PCI Express 3.0,, USB 3.1', 9360.00, 2)//

INSERT INTO products
  (name, description, price, catalog_id)
VALUES
  (NULL, 'HDMI, SATA3, PCI Express 3.0,, USB 3.1', 9360.00, 2)//

CREATE TRIGGER validate_name_description_update BEFORE UPDATE ON products
FOR EACH ROW BEGIN
  IF NEW.name IS NULL AND NEW.description IS NULL THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Both name and description are NULL';
  END IF;
END//

DELIMITER ;

