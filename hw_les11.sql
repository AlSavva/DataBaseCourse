-- Задание 1
-- Создайте таблицу logs типа Archive. Пусть при каждом создании записи в таблицах users, 
-- catalogs и products в таблицу logs помещается время и дата создания записи, название 
-- таблицы, идентификатор первичного ключа и содержимое поля name.


CREATE TABLE logs (
	created_at DATETIME NOT NULL,
	table_name VARCHAR(45) NOT NULL,
	key_id BIGINT(20) NOT NULL,
	name_content VARCHAR(45) NOT NULL
) ENGINE = ARCHIVE;

-- Создаем триггеры для таблиц users, catalogs, products

DROP TRIGGER IF EXISTS users_insert;
delimiter //
CREATE TRIGGER users_insert AFTER INSERT ON users
FOR EACH ROW
BEGIN
	INSERT INTO logs (created_at, table_name, key_id, name_content)
	VALUES (NOW(), 'users', NEW.id, NEW.name);
END //
delimiter ;

DROP TRIGGER IF EXISTS catalogs_insert;
delimiter //
CREATE TRIGGER catalogs_insert AFTER INSERT ON catalogs
FOR EACH ROW
BEGIN
	INSERT INTO logs (created_at, table_name, key_id, name_content)
	VALUES (NOW(), 'catalogs', NEW.id, NEW.name);
END //
delimiter ;

delimiter //
CREATE TRIGGER products_insert AFTER INSERT ON products
FOR EACH ROW
BEGIN
	INSERT INTO logs (created_at, table_name, key_id, name_content)
	VALUES (NOW(), 'products', NEW.id, NEW.name);
END //
delimiter ;


-- Заполняем таблицы:

INSERT INTO catalogs VALUES
  (NULL, 'Процессоры'),
  (NULL, 'Материнские платы'),
  (NULL, 'Видеокарты'),
  (NULL, 'Жесткие диски'),
  (NULL, 'Оперативная память');
 
INSERT INTO users (name, birthday_at) VALUES
  ('Александр', '1985-05-20'),
  ('Сергей', '1988-02-14'),
  ('Иван', '1998-01-12'),
  ('Мария', '1992-08-29');

INSERT INTO products
  (name, description, price, catalog_id)
VALUES
  ('Intel Core i3-8100', 'Процессор Intel.', 7890.00, 1),
  ('Intel Core i5-7400', 'Процессор Intel.', 12700.00, 1),
  ('AMD FX-8320E', 'Процессор AMD.', 4780.00, 1),
  ('AMD FX-8320', 'Процессор AMD.', 7120.00, 1),
  ('ASUS ROG MAXIMUS X HERO', 'Материнская плата ASUS', 19310.00, 2),
  ('Gigabyte H310M S2H', 'Материнская плата Gigabyte', 4790.00, 2),
  ('MSI B250M GAMING PRO', 'Материнская плата MSI', 5060.00, 2);
 
-- Проверяем результат:

SELECT * FROM logs;

/*
mysql> USE sample;
Reading table information for completion of table and column names
You can turn off this feature to get a quicker startup with -A

Database changed
mysql> CREATE TABLE logs (
    ->   created_at DATETIME NOT NULL,
    ->   table_name VARCHAR(45) NOT NULL,
    ->   key_id BIGINT(20) NOT NULL,
    ->   name_content VARCHAR(45) NOT NULL
    -> ) ENGINE = ARCHIVE;
Query OK, 0 rows affected, 1 warning (0.00 sec)

mysql> delimiter //
mysql> CREATE TRIGGER users_insert AFTER INSERT ON users
    -> FOR EACH ROW
    -> BEGIN
    ->     INSERT INTO logs (created_at, table_name, key_id, name_content)
    ->     VALUES (NOW(), 'users', NEW.id, NEW.name);
    -> END //
Query OK, 0 rows affected (0.29 sec)

mysql> delimiter ;

delimiter //
mysql> CREATE TRIGGER catalogs_insert AFTER INSERT ON catalogs
    -> FOR EACH ROW
    -> BEGIN
    ->     INSERT INTO logs (created_at, table_name, key_id, name_content)
    ->     VALUES (NOW(), 'catalogs', NEW.id, NEW.name);
    -> END //
Query OK, 0 rows affected (0.00 sec)

mysql> delimiter ;

mysql> delimiter //
mysql> CREATE TRIGGER products_insert AFTER INSERT ON products
    -> FOR EACH ROW
    -> BEGIN
    ->     INSERT INTO logs (created_at, table_name, key_id, name_content)
    ->     VALUES (NOW(), 'products', NEW.id, NEW.name);
    -> END //
Query OK, 0 rows affected (0.00 sec)

mysql> delimiter ;

mysql> INSERT INTO catalogs VALUES
    ->     (NULL, 'Процессоры'),
    ->     (NULL, 'Материнские платы'),
    ->     (NULL, 'Видеокарты'),
    ->     (NULL, 'Жесткие диски'),
    ->     (NULL, 'Оперативная память');
Query OK, 5 rows affected (0.01 sec)
Records: 5  Duplicates: 0  Warnings: 0

mysql> INSERT INTO users (name, birthday_at) VALUES
    ->     ('Александр', '1985-05-20'),
    ->     ('Сергей', '1988-02-14'),
    ->     ('Иван', '1998-01-12'),
    ->     ('Мария', '1992-08-29');
Query OK, 4 rows affected (0.00 sec)
Records: 4  Duplicates: 0  Warnings: 0

mysql> INSERT INTO products
    ->   (name, description, price, catalog_id)
    -> VALUES
    ->   ('Intel Core i3-8100', 'Процессор Intel.', 7890.00, 1),
    ->   ('Intel Core i5-7400', 'Процессор Intel.', 12700.00, 1),
    ->   ('AMD FX-8320E', 'Процессор AMD.', 4780.00, 1),
    ->   ('AMD FX-8320', 'Процессор AMD.', 7120.00, 1),
    ->   ('ASUS ROG MAXIMUS X HERO', 'Материнская плата ASUS', 19310.00, 2),
    ->   ('Gigabyte H310M S2H', 'Материнская плата Gigabyte', 4790.00, 2),
    ->   ('MSI B250M GAMING PRO', 'Материнская плата MSI', 5060.00, 2);
Query OK, 7 rows affected (0.01 sec)
Records: 7  Duplicates: 0  Warnings: 0

mysql> SELECT * FROM logs;
+---------------------+------------+--------+-------------------------------------+
| created_at          | table_name | key_id | name_content                        |
+---------------------+------------+--------+-------------------------------------+
| 2020-12-11 14:32:06 | catalogs   |      6 | Процессоры                          |
| 2020-12-11 14:32:06 | catalogs   |      7 | Материнские платы                   |
| 2020-12-11 14:32:06 | catalogs   |      8 | Видеокарты                          |
| 2020-12-11 14:32:06 | catalogs   |      9 | Жесткие диски                       |
| 2020-12-11 14:32:06 | catalogs   |     10 | Оперативная память                  |
| 2020-12-11 14:33:51 | users      |      2 | Александр                           |
| 2020-12-11 14:33:51 | users      |      3 | Сергей                              |
| 2020-12-11 14:33:51 | users      |      4 | Иван                                |
| 2020-12-11 14:33:51 | users      |      5 | Мария                               |
| 2020-12-11 14:37:45 | products   |      8 | Intel Core i3-8100                  |
| 2020-12-11 14:37:45 | products   |      9 | Intel Core i5-7400                  |
| 2020-12-11 14:37:45 | products   |     10 | AMD FX-8320E                        |
| 2020-12-11 14:37:45 | products   |     11 | AMD FX-8320                         |
| 2020-12-11 14:37:45 | products   |     12 | ASUS ROG MAXIMUS X HERO             |
| 2020-12-11 14:37:45 | products   |     13 | Gigabyte H310M S2H                  |
| 2020-12-11 14:37:45 | products   |     14 | MSI B250M GAMING PRO                |
+---------------------+------------+--------+-------------------------------------+
16 rows in set (0.00 sec)
*/


-- Задание 2:
-- (по желанию) Создайте SQL-запрос, который помещает в таблицу users миллион записей.

DROP PROCEDURE IF EXISTS users_generator;
delimiter //
CREATE PROCEDURE users_generator (IN i INT)
BEGIN
	DECLARE j INT DEFAULT 0;
	WHILE i > 0 DO
		INSERT INTO users(name, birthday_at) VALUES (CONCAT('username_', j), NOW());
		SET j = j + 1;
		SET i = i - 1;
	END WHILE;
END //
delimiter ;

-- Запускаем процедуру на вставку 100000 пользователей(на миллион не решился)б
-- время вставки 1 min 2.66 sec

CALL users_generator(100000);

-- Смотрим результат:

SELECT * FROM users ORDER BY name DESC LIMIT 50;

-- Результат:
/*
mysql> delimiter //

mysql> CREATE PROCEDURE users_generator(IN i INT)
    -> BEGIN
    ->     DECLARE j INT DEFAULT 0;
    ->     WHILE i > 0 DO
    ->         INSERT INTO users(name, birthday_at) VALUES (CONCAT('username_', j), NOW());
    ->         SET j = j + 1;
    ->         SET i = i - 1;
    ->     END WHILE;
    -> END//
Query OK, 0 rows affected (0.01 sec)

mysql> delimiter ;
mysql> CALL users_generator(100000);
^C^C -- query aborted
Query OK, 1 row affected (1 min 2.66 sec)

mysql> SELECT * FROM users ORDER BY name DESC LIMIT 50;
+--------+--------------------+-------------+---------------------+---------------------+
| id     | name               | birthday_at | created_at          | updated_at          |
+--------+--------------------+-------------+---------------------+---------------------+
|      2 | Сергей             | 1988-02-14  | 2020-12-11 14:58:41 | 2020-12-11 14:58:41 |
|      4 | Мария              | 1992-08-29  | 2020-12-11 14:58:41 | 2020-12-11 14:58:41 |
|      3 | Иван               | 1998-01-12  | 2020-12-11 14:58:41 | 2020-12-11 14:58:41 |
|      1 | Александр          | 1985-05-20  | 2020-12-11 14:58:41 | 2020-12-11 14:58:41 |
| 100004 | username_99999     | 2020-12-11  | 2020-12-11 15:15:51 | 2020-12-11 15:15:51 |
| 100003 | username_99998     | 2020-12-11  | 2020-12-11 15:15:51 | 2020-12-11 15:15:51 |
| 100002 | username_99997     | 2020-12-11  | 2020-12-11 15:15:51 | 2020-12-11 15:15:51 |
| 100001 | username_99996     | 2020-12-11  | 2020-12-11 15:15:51 | 2020-12-11 15:15:51 |
| 100000 | username_99995     | 2020-12-11  | 2020-12-11 15:15:51 | 2020-12-11 15:15:51 |
|  99999 | username_99994     | 2020-12-11  | 2020-12-11 15:15:51 | 2020-12-11 15:15:51 |
|  99998 | username_99993     | 2020-12-11  | 2020-12-11 15:15:51 | 2020-12-11 15:15:51 |
|  99997 | username_99992     | 2020-12-11  | 2020-12-11 15:15:51 | 2020-12-11 15:15:51 |
|  99996 | username_99991     | 2020-12-11  | 2020-12-11 15:15:51 | 2020-12-11 15:15:51 |
|  99995 | username_99990     | 2020-12-11  | 2020-12-11 15:15:51 | 2020-12-11 15:15:51 |
|  10004 | username_9999      | 2020-12-11  | 2020-12-11 15:14:55 | 2020-12-11 15:14:55 |
|  99994 | username_99989     | 2020-12-11  | 2020-12-11 15:15:51 | 2020-12-11 15:15:51 |
|  99993 | username_99988     | 2020-12-11  | 2020-12-11 15:15:51 | 2020-12-11 15:15:51 |
|  99992 | username_99987     | 2020-12-11  | 2020-12-11 15:15:51 | 2020-12-11 15:15:51 |
|  99991 | username_99986     | 2020-12-11  | 2020-12-11 15:15:51 | 2020-12-11 15:15:51 |
|  99990 | username_99985     | 2020-12-11  | 2020-12-11 15:15:51 | 2020-12-11 15:15:51 |
|  99989 | username_99984     | 2020-12-11  | 2020-12-11 15:15:51 | 2020-12-11 15:15:51 |
|  99988 | username_99983     | 2020-12-11  | 2020-12-11 15:15:51 | 2020-12-11 15:15:51 |
|  99987 | username_99982     | 2020-12-11  | 2020-12-11 15:15:51 | 2020-12-11 15:15:51 |
|  99986 | username_99981     | 2020-12-11  | 2020-12-11 15:15:51 | 2020-12-11 15:15:51 |
|  99985 | username_99980     | 2020-12-11  | 2020-12-11 15:15:51 | 2020-12-11 15:15:51 |
|  10003 | username_9998      | 2020-12-11  | 2020-12-11 15:14:55 | 2020-12-11 15:14:55 |
|  99984 | username_99979     | 2020-12-11  | 2020-12-11 15:15:51 | 2020-12-11 15:15:51 |
|  99983 | username_99978     | 2020-12-11  | 2020-12-11 15:15:51 | 2020-12-11 15:15:51 |
|  99982 | username_99977     | 2020-12-11  | 2020-12-11 15:15:51 | 2020-12-11 15:15:51 |
|  99981 | username_99976     | 2020-12-11  | 2020-12-11 15:15:51 | 2020-12-11 15:15:51 |
|  99980 | username_99975     | 2020-12-11  | 2020-12-11 15:15:51 | 2020-12-11 15:15:51 |
|  99979 | username_99974     | 2020-12-11  | 2020-12-11 15:15:51 | 2020-12-11 15:15:51 |
|  99978 | username_99973     | 2020-12-11  | 2020-12-11 15:15:51 | 2020-12-11 15:15:51 |
|  99977 | username_99972     | 2020-12-11  | 2020-12-11 15:15:51 | 2020-12-11 15:15:51 |
|  99976 | username_99971     | 2020-12-11  | 2020-12-11 15:15:51 | 2020-12-11 15:15:51 |
|  99975 | username_99970     | 2020-12-11  | 2020-12-11 15:15:51 | 2020-12-11 15:15:51 |
|  10002 | username_9997      | 2020-12-11  | 2020-12-11 15:14:55 | 2020-12-11 15:14:55 |
|  99974 | username_99969     | 2020-12-11  | 2020-12-11 15:15:51 | 2020-12-11 15:15:51 |
|  99973 | username_99968     | 2020-12-11  | 2020-12-11 15:15:51 | 2020-12-11 15:15:51 |
|  99972 | username_99967     | 2020-12-11  | 2020-12-11 15:15:51 | 2020-12-11 15:15:51 |
|  99971 | username_99966     | 2020-12-11  | 2020-12-11 15:15:51 | 2020-12-11 15:15:51 |
|  99970 | username_99965     | 2020-12-11  | 2020-12-11 15:15:51 | 2020-12-11 15:15:51 |
|  99969 | username_99964     | 2020-12-11  | 2020-12-11 15:15:51 | 2020-12-11 15:15:51 |
|  99968 | username_99963     | 2020-12-11  | 2020-12-11 15:15:51 | 2020-12-11 15:15:51 |
|  99967 | username_99962     | 2020-12-11  | 2020-12-11 15:15:51 | 2020-12-11 15:15:51 |
|  99966 | username_99961     | 2020-12-11  | 2020-12-11 15:15:51 | 2020-12-11 15:15:51 |
|  99965 | username_99960     | 2020-12-11  | 2020-12-11 15:15:51 | 2020-12-11 15:15:51 |
|  10001 | username_9996      | 2020-12-11  | 2020-12-11 15:14:55 | 2020-12-11 15:14:55 |
|  99964 | username_99959     | 2020-12-11  | 2020-12-11 15:15:51 | 2020-12-11 15:15:51 |
|  99963 | username_99958     | 2020-12-11  | 2020-12-11 15:15:51 | 2020-12-11 15:15:51 |
+--------+--------------------+-------------+---------------------+---------------------+
50 rows in set (0.03 sec)
