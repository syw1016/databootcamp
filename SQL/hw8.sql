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
GROUP BY last_name;

SELECT last_name, last_name_count
FROM ( SELECT last_name, count(last_name) AS last_name_count
				FROM actor
                GROUP BY last_name ) last_name_count_table
WHERE last_name_count > 1;

UPDATE actor
SET first_name = 'HARPO', last_name = 'WILLIAMS'
WHERE first_name = 'GROUCHO' AND last_name = 'WILLIAMS';

UPDATE actor
SET first_name = ( CASE WHEN first_name = 'GROUCHO' THEN 'MUCHO GROUCHO'
										  WHEN first_name = 'HARPO' THEN  'GROUCHO' 
								END )
WHERE actor_id = 172;

DESCRIBE address;

SELECT staff.first_name, staff.last_name, address.address
FROM staff
JOIN address
ON staff.address_id = address.address_id;

SELECT staff.first_name, staff.last_name, sum(payment.amount)
FROM staff
JOIN payment
ON staff.staff_id = payment.staff_id
GROUP BY staff.first_name, staff.last_name;

SELECT film.title, count(actor_id)
FROM film_actor
INNER JOIN film
ON film_actor.film_id = film.film_id
GROUP BY film.title;

SELECT count(inventory_id)
FROM inventory
LEFT JOIN film
ON inventory.film_id = film.film_id
WHERE film.title = 'Hunchback Impossible';

SELECT customer.first_name, customer.last_name, sum(payment.amount)
FROM payment
JOIN customer
ON payment.customer_id = customer.customer_id
GROUP BY customer.first_name, customer.last_name
ORDER BY customer.last_name;

SELECT title 
FROM film
WHERE (title LIKE 'K%' OR title LIKE 'Q%')
AND language_id IN (
	SELECT language_id 
    FROM language
	WHERE name = 'English');
    
SELECT first_name, last_name
FROM actor
WHERE actor_id IN (
	SELECT actor_id
    FROM film_actor
    WHERE film_id = (
		SELECT film_id
        FROM film
        WHERE title = 'Alone Trip'
    )
);

SELECT c.first_name, c.last_name, c.email, country.country
FROM customer c
JOIN address a
ON c.address_id = a.address_id
JOIN city
ON a.city_id = city.city_id
JOIN country
ON city.country_id = country.country_id
WHERE country.country = 'Canada';

SELECT f.title
FROM film f
JOIN film_category fc
ON f.film_id = fc.film_id
WHERE fc.category_id IN (
	SELECT category_id
    FROM category
    WHERE name = 'Family'
);

SELECT f.title, count(r.rental_id) as rental
FROM rental r 
JOIN inventory i
ON r.inventory_id = i.inventory_id
JOIN film f
ON i.film_id = f.film_id
GROUP BY f.title
ORDER BY rental DESC;

SELECT st.store_id, SUM(p.amount)
FROM payment p
JOIN staff s
ON p.staff_id = s.staff_id
JOIN store st
ON s.store_id = st.store_id
GROUP BY st.store_Id;

SELECT store_id, city, country
FROM store st
JOIN address ad
ON st.address_id = ad.address_id
JOIN city
ON ad.city_id = city.city_id
JOIN country
ON city.country_id = country.country_id;

SELECT c.name, SUM(p.amount) AS revenue
FROM payment p
JOIN rental r
ON r.rental_id = p.rental_id
JOIN inventory i
ON r.inventory_id = i.inventory_id
JOIN film_category fc
ON i.film_id = fc.film_id
JOIN category c
ON fc.category_id = c.category_id
GROUP BY c.name
ORDER BY revenue DESC
LIMIT 5;

CREATE VIEW executive_view AS
SELECT c.name, SUM(p.amount) AS revenue
FROM payment p
JOIN rental r
ON r.rental_id = p.rental_id
JOIN inventory i
ON r.inventory_id = i.inventory_id
JOIN film_category fc
ON i.film_id = fc.film_id
JOIN category c
ON fc.category_id = c.category_id
GROUP BY c.name
ORDER BY revenue DESC
LIMIT 5;

SELECT * FROM sakila.executive_view;

DROP VIEW executive_view;
