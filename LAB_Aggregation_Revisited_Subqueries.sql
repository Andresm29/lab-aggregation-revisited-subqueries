# In this lab, you will be using the Sakila database of movie rentals.
USE sakila;

-- Instructions
-- Write the SQL queries to answer the following questions:

# 1. Select the first name, last name, and email address of all the customers who have rented a movie.

SELECT film_id, title
FROM film;

SELECT c.first_name, c.last_name, c.email
FROM customer c
JOIN rental r ON c.customer_id = r.customer_id
JOIN inventory i ON r.inventory_id = i.inventory_id
WHERE i.film_id = 6; -- I chose film_id 6 'AGENT TRUMAN' to display the requested info


# 2. What is the average payment made by each customer (display the customer id, customer name (concatenated), and the average payment made).

SELECT p.customer_id, CONCAT(c.first_name, ' ', c.last_name) AS "Customer Name", AVG(p.amount) AS "Average Payment"
FROM payment p
JOIN customer c ON p.customer_id = c.customer_id
GROUP BY p.customer_id;


# 3. Select the name and email address of all the customers who have rented the "Action" movies.

# 3.1 Write the query using multiple join statements
SELECT DISTINCT
    c.first_name, c.last_name, c.email
FROM
    customer c
        JOIN
    rental r ON c.customer_id = r.customer_id
        JOIN
    inventory i ON r.inventory_id = i.inventory_id
        JOIN
    film_category fc ON i.film_id = fc.film_id
        JOIN
    category cat ON fc.category_id = cat.category_id
WHERE
    cat.name = "Action";

# 3.2 Write the query using sub queries with multiple WHERE clause and IN condition
SELECT 
    c.first_name, c.last_name, c.email
FROM
    customer c
WHERE
    c.customer_id IN (SELECT 
            r.customer_id
        FROM
            rental r
        WHERE
            r.inventory_id IN (SELECT 
                    i.inventory_id
                FROM
                    inventory i
                WHERE
                    i.film_id IN (SELECT 
                            fc.film_id
                        FROM
                            film_category fc
                                JOIN
                            category cat ON fc.category_id = cat.category_id
                        WHERE
                            cat.name = 'Action')));


-- Verify if the above two queries produce the same results or not
-- They both produce the same results


# 4. Use the case statement to create a new column classifying existing columns as either or high value transactions based on the amount of payment. 
# If the amount is between 0 and 2, label should be low and if the amount is between 2 and 4, the label should be medium, and if it is more than 4, then it should be high.

SELECT p.amount, 
CASE 
    WHEN p.amount BETWEEN 0 AND 2 THEN "Low"
    WHEN p.amount BETWEEN 2 AND 4 THEN "Medium"
    ELSE "High"
END as "payment_classification"
FROM payment p;