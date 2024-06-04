--1
UPDATE film
SET rental_duration = 21, rental_rate = 9.99
WHERE title = 'Drive';
--2
UPDATE customer
SET first_name = 'bahdan', 
    last_name = 'kanoplich', 
    email = 'bahdan.kanoplich@student.ehu.lt', 
    address_id = (SELECT address_id FROM address LIMIT 1), 
    last_update = CURRENT_TIMESTAMP
WHERE customer_id = (
  SELECT rental_counts.customer_id 
  FROM (
    SELECT customer_id, COUNT(*) as rental_count
    FROM rental
    GROUP BY customer_id
    HAVING COUNT(*) >= 10
  ) as rental_counts
  JOIN (
    SELECT customer_id, COUNT(*) as payment_count
    FROM payment
    GROUP BY customer_id
    HAVING COUNT(*) >= 10
  ) as payment_counts
  ON rental_counts.customer_id = payment_counts.customer_id
  LIMIT 1
);
--3
UPDATE customer
SET create_date = CURRENT_DATE
WHERE first_name = 'bahdan' AND last_name = 'kanoplich' AND email = 'bahdan.kanoplich@student.ehu.lt';
