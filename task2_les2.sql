-- ������� 2
-- �������� ���� ������ example, ���������� � ��� ������� users, ���������
-- �� ���� ��������, ��������� id � ���������� name.

CREATE DATABASE IF NOT EXISTS example;
USE example;
CREATE TABLE IF NOT EXISTS user(
id INT UNSIGNED NOT NULL AUTO_INCREMENT UNIQUE,
name VARCHAR(255) NOT NULL UNIQUE
);