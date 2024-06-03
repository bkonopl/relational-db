--1
WITH staff_payments AS (
  SELECT st.store_id, r.staff_id, SUM(p.amount) as total_amount,
         ROW_NUMBER() OVER(PARTITION BY st.store_id ORDER BY SUM(p.amount) DESC) as rn
  FROM rental r
  JOIN staff st ON r.staff_id = st.staff_id AND EXTRACT(YEAR FROM r.rental_date) = 2017
  JOIN payment p ON r.rental_id = p.rental_id
  GROUP BY st.store_id, r.staff_id
)
SELECT store_id, staff_id, total_amount
FROM staff_payments
WHERE rn = 1;

--2
SELECT f.film_id, f.title, f.rating, COUNT(r.rental_id) as rental_count
FROM rental r
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
GROUP BY f.film_id, f.title, f.rating
ORDER BY rental_count DESC
LIMIT 5;

--3
SELECT fa.actor_id, MAX(fa.last_update) as last_film_date
FROM rental r
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
JOIN film_actor fa ON f.film_id = fa.film_id
GROUP BY fa.actor_id
ORDER BY last_film_date DESC;