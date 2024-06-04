--1 
INSERT INTO film 
(title, description, release_year, language_id, original_language_id, rental_duration, rental_rate, length, replacement_cost, rating, special_features, last_update) 
VALUES 
( 'Drive', 'A mysterious Hollywood stuntman and mechanic moonlights as a getaway driver and finds himself in trouble when he helps out his neighbor.', 2011, 1, NULL, 2, 4.99, 100, 19.99, 'R', '{Behind the Scenes}', CURRENT_TIMESTAMP);

--2
INSERT INTO actor (first_name, last_name, last_update) 
VALUES ('Ryan', 'Gosling', CURRENT_TIMESTAMP),
       ('Carey', 'Mulligan', CURRENT_TIMESTAMP),
       ('Bryan', 'Cranston', CURRENT_TIMESTAMP);

INSERT INTO film_actor (film_id, actor_id, last_update) 
SELECT (SELECT film_id FROM film WHERE title = 'Drive'), actor_id, CURRENT_TIMESTAMP FROM actor 
WHERE first_name IN ('Ryan', 'Carey', 'Bryan') AND last_name IN ('Gosling', 'Mulligan', 'Cranston');

--3
INSERT INTO inventory (film_id, store_id, last_update)
VALUES ((SELECT film_id FROM film WHERE title = 'Drive'), 1, CURRENT_TIMESTAMP);