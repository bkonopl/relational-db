-- 1
CREATE OR REPLACE VIEW sales_revenue_by_category_qtr AS
SELECT
    c.name AS category, 
    COUNT(*) AS sales_count
FROM 
    rental r
JOIN
    inventory i ON r.inventory_id = i.inventory_id
JOIN 
    film_category fc ON i.film_id = fc.film_id
JOIN 
    category c ON fc.category_id = c.category_id
WHERE 
    DATE_TRUNC('quarter', r.rental_date) = DATE_TRUNC('quarter', CURRENT_DATE)
GROUP BY 
    c.name
HAVING 
    COUNT(*) > 0;
select * from sales_revenue_by_category_qtr;

--  2
CREATE OR REPLACE FUNCTION get_sales_revenue_by_category_qtr(p_year INTEGER, p_quarter INTEGER)
RETURNS TABLE(category character varying(25), sales_count BIGINT) AS
$$
BEGIN
    RETURN QUERY
    SELECT
        c.name AS category,
        COUNT(*) AS sales_count
    FROM 
        rental r
    JOIN 
        inventory i ON r.inventory_id = i.inventory_id
    JOIN 
        film_category fc ON i.film_id = fc.film_id
    JOIN 
        category c ON fc.category_id = c.category_id
    WHERE 
        EXTRACT(YEAR FROM r.rental_date) = p_year AND
        EXTRACT(QUARTER FROM r.rental_date) = p_quarter
    GROUP BY 
        c.name
    HAVING 
        COUNT(*) > 0;
END
$$
LANGUAGE plpgsql;
SELECT * FROM get_sales_revenue_by_category_qtr(2006, 1);
-- 3
CREATE OR REPLACE PROCEDURE new_movie(p_title TEXT)
LANGUAGE PLPGSQL
AS
$$
DECLARE
    v_language_id INTEGER;
    v_max_film_id INTEGER;
BEGIN
    -- Check if the language 'Klingon' exists
    SELECT language_id INTO v_language_id
    FROM language
    WHERE name = 'Klingon';

    -- If 'Klingon' does not exist, insert it
    IF v_language_id IS NULL THEN
        INSERT INTO language(name) VALUES ('Klingon') 
        RETURNING language_id INTO v_language_id;
    END IF;
    
    -- Fetch the max film_id to generate a new unique id 
    SELECT max(film_id) INTO v_max_film_id
    FROM film;

    -- Insert the new movie
    INSERT INTO film(film_id, title, rental_duration, rental_rate, replacement_cost, release_year, language_id)
    VALUES (v_max_film_id + 1, p_title, 3, 4.99, 19.99, EXTRACT(YEAR FROM CURRENT_DATE), v_language_id);
END
$$;
CALL new_movie('Your New Movie Title');