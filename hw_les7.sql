-- Задание 1
-- Составьте список пользователей users, которые осуществили хотя бы один заказ orders в интернет магазине.

/*
 в базе shop создаём таблицы orders, orders_products, и заполняем их. 
 
 CREATE TABLE orders (
  id SERIAL PRIMARY KEY,
  user_id INT UNSIGNED,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  KEY index_of_user_id(user_id)
);

CREATE TABLE orders_products (
  id SERIAL PRIMARY KEY,
  order_id INT UNSIGNED,
  product_id INT UNSIGNED,
  total INT UNSIGNED DEFAULT 1,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

INSERT INTO orders (user_id)
SELECT id FROM users WHERE name = 'Геннадий';

INSERT INTO orders_products (order_id, product_id, total)
SELECT LAST_INSERT_ID(), id, 2 FROM products
WHERE name = 'Intel Core i5-7400';

INSERT INTO orders (user_id)
SELECT id FROM users WHERE name = 'Наталья';

INSERT INTO orders_products (order_id, product_id, total)
SELECT LAST_INSERT_ID(), id, 1 FROM products
WHERE name IN ('Intel Core i5-7400', 'Gigabyte H310M S2H');

INSERT INTO orders (user_id)
SELECT id FROM users WHERE name = 'Иван';

INSERT INTO orders_products (order_id, product_id, total)
SELECT LAST_INSERT_ID(), id, 1 FROM products
WHERE name IN ('AMD FX-8320', 'ASUS ROG MAXIMUS X HERO');

 */

SELECT u.id, u.name
  FROM users AS u
   JOIN orders AS o
     ON u.id = o.user_id;
    
-- Результат:
/*
 mysql> SELECT * FROM orders;
+----+---------+---------------------+---------------------+
| id | user_id | created_at          | updated_at          |
+----+---------+---------------------+---------------------+
|  1 |       1 | 2020-12-01 12:20:21 | 2020-12-01 12:20:21 |
|  2 |       2 | 2020-12-01 12:20:28 | 2020-12-01 12:20:28 |
|  3 |       5 | 2020-12-01 12:20:34 | 2020-12-01 12:20:34 |
+----+---------+---------------------+---------------------+
3 rows in set (0.00 sec)

mysql> SELECT u.id, u.name
    ->   FROM users AS u
    ->    JOIN orders AS o
    ->      ON u.id = o.user_id;
+----+------------------+
| id | name             |
+----+------------------+
|  1 | Геннадий         |
|  2 | Наталья          |
|  5 | Иван             |
+----+------------------+
3 rows in set (0.00 sec)
 */
    
    
    
-- Задание 2
-- Выведите список товаров products и разделов catalogs, который соответствует товару

SELECT
  p.id,
  p.name,
  c.name AS catalog
  FROM products AS p
    LEFT JOIN catalogs AS c
      ON p.catalog_id = c.id;
     
-- Результат:
/*
 mysql> SELECT
    ->   p.id,
    ->   p.name,
    ->   c.name AS catalog
    ->   FROM products AS p
    ->     LEFT JOIN catalogs AS c
    ->       ON p.catalog_id = c.id;
+----+-------------------------+-----------------------------------+
| id | name                    | catalog                           |
+----+-------------------------+-----------------------------------+
|  1 | Intel Core i3-8100      | Процессоры                        |
|  2 | Intel Core i5-7400      | Процессоры                        |
|  3 | AMD FX-8320E            | Процессоры                        |
|  4 | AMD FX-8320             | Процессоры                        |
|  5 | ASUS ROG MAXIMUS X HERO | Материнские платы                 |
|  6 | Gigabyte H310M S2H      | Материнские платы                 |
|  7 | MSI B250M GAMING PRO    | Материнские платы                 |
+----+-------------------------+-----------------------------------+
7 rows in set (0.00 sec)

 */



-- Задание 3
-- (по желанию) Пусть имеется таблица рейсов flights (id, from, to) и таблица городов cities (label, name). 
-- Поля from, to и label содержат английские названия городов, поле name — русское. Выведите список рейсов 
-- flights с русскими названиями городов.

-- Создаём таблицы
CREATE TABLE flights (
  id SERIAL PRIMARY KEY,
  `from` VARCHAR(255),
  `to` VARCHAR(255)
);


CREATE TABLE cities (
  id SERIAL PRIMARY KEY,
  label VARCHAR(255),
  name VARCHAR(255)
);

-- Заполняем:

INSERT INTO cities (label, name) VALUES
('moscow', 'Москва'),
('irkutsk', 'Иркутск'),
('novgorod', 'Новгород'),
('kazan', 'Казань'),
('omsk', 'Омск');

INSERT INTO flights (`from`, `to`) VALUES
('moscow', 'omsk'),
('novgorod', 'kazan'),
('irkutsk', 'moscow'),
('omsk', 'irkutsk'),
('moscow', 'kazan');


SELECT
  f.id,
  cities_from.name AS `from`,
  cities_to.name AS `to`
FROM flights AS f
  JOIN cities AS cities_from
    ON f.from = cities_from.label
  JOIN cities AS cities_to
    ON f.to = cities_to.label
ORDER BY
  f.id;
   
-- Результат:

/*mysql> SELECT * FROM flights;
+----+----------+---------+
| id | from     | to      |
+----+----------+---------+
|  1 | moscow   | omsk    |
|  2 | novgorod | kazan   |
|  3 | irkutsk  | moscow  |
|  4 | omsk     | irkutsk |
|  5 | moscow   | kazan   |
+----+----------+---------+
5 rows in set (0.00 sec)

mysql> SELECT * FROM  cities;
+----+----------+------------------+
| id | label    | name             |
+----+----------+------------------+
|  1 | moscow   | Москва           |
|  2 | irkutsk  | Иркутск          |
|  3 | novgorod | Новгород         |
|  4 | kazan    | Казань           |
|  5 | omsk     | Омск             |
+----+----------+------------------+
5 rows in set (0.00 sec)

mysql> SELECT
    ->   f.id,
    ->   cities_from.name AS `from`,
    ->   cities_to.name AS `to`
    -> FROM flights AS f
    ->   JOIN cities AS cities_from
    ->     ON f.from = cities_from.label
    ->   JOIN cities AS cities_to
    ->     ON f.to = cities_to.label
    -> ORDER BY
    ->   f.id;
+----+------------------+----------------+
| id | from             | to             |
+----+------------------+----------------+
|  1 | Москва           | Омск           |
|  2 | Новгород         | Казань         |
|  3 | Иркутск          | Москва         |
|  4 | Омск             | Иркутск        |
|  5 | Москва           | Казань         |
+----+------------------+----------------+
5 rows in set (0.00 sec)


 */


