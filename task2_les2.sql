-- Задание 2
-- Создайте базу данных example, разместите в ней таблицу users, состоящую
-- из двух столбцов, числового id и строкового name.

CREATE DATABASE IF NOT EXISTS example;
USE example;
CREATE TABLE IF NOT EXISTS user(
id INT UNSIGNED NOT NULL AUTO_INCREMENT UNIQUE,
name VARCHAR(255) NOT NULL UNIQUE
);