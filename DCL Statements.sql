-- 1
GRANT SELECT ON customer TO rentaluser;
-- 2
CREATE ROLE rental;
GRANT rental TO rentaluser;
-- 3
INSERT INTO rental(rental_date, inventory_id, customer_id, return_date, staff_id, last_update)
VALUES (current_date, 1526, 460, current_date, 2, current_date);

UPDATE rental 
SET return_date = current_date, last_update = current_date 
WHERE rental_id = 2;
-- 4
REVOKE INSERT ON rental FROM rental;
-- 5
CREATE ROLE client_Jared_Ely;

ALTER TABLE rental ENABLE ROW LEVEL SECURITY;
ALTER TABLE payment ENABLE ROW LEVEL SECURITY;
CREATE POLICY rental_policy_for_client_Jared_Ely ON rental
USING (customer_id = (SELECT customer_id FROM customer WHERE first_name = 'Jared' AND last_name = 'Ely'))
WITH CHECK (customer_id = (SELECT customer_id FROM customer WHERE first_name = 'Jared' AND last_name = 'Ely'));

CREATE POLICY payment_policy_for_client_Jared_Ely ON payment
USING (customer_id = (SELECT customer_id FROM customer WHERE first_name = 'Jared' AND last_name = 'Ely'))
WITH CHECK (customer_id = (SELECT customer_id FROM customer WHERE first_name = 'Jared' AND last_name = 'Ely'));

GRANT SELECT ON rental, payment TO client_Jared_Ely;