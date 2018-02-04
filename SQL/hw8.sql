USE sakila;

SELECT first_name, last_name, CONCAT(first_name, ' ', last_name) AS `Actor Name`
FROM actor;

SELECT actor_id, first_name, last_name
FROM actor
WHERE first_name = 'Joe';

SELECT *
FROM actor
WHERE last_name LIKE '%GEN%';

SELECT *
FROM actor
WHERE last_name LIKE '%LI%'
ORDER BY last_name, first_name;

SELECT country_id, country
FROM country
WHERE country IN ('Afghanistan', 'Bangladesh', 'China');

ALTER TABLE `sakila`.`actor` 
ADD COLUMN `middle_name` VARCHAR(45) NULL AFTER `first_name`;

ALTER TABLE `sakila`.`actor` 
CHANGE COLUMN `middle_name` `middle_name` BLOB NULL DEFAULT NULL ;

ALTER TABLE `sakila`.`actor` 
DROP COLUMN `middle_name`;

SELECT last_name, count(last_name)
FROM actor
GROUP BY last_name


