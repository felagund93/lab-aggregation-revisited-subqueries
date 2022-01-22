# Lab | Aggregation Revisited - Sub queries

#In this lab, you will be using the [Sakila](https://dev.mysql.com/doc/sakila/en/) database of movie rentals. 
#You have been using this database for a couple labs already, but if you need to get the data again, refer to the official [installation link]
#(https://dev.mysql.com/doc/sakila/en/sakila-installation.html).

### Instructions

#Write the SQL queries to answer the following questions:

  -- Select the first name, last name, and email address of all the customers who have rented a movie.
  
#1) Query to select Customers that have rented a movie -> Distinct customer_id's in rental table
SELECT DISTINCT customer_id FROM sakila.rental;

#2) Query to join customer table with subquery in #1)
SELECT c.last_name, c.first_name, c.email FROM sakila.customer AS c
JOIN (
SELECT DISTINCT customer_id FROM sakila.rental
) AS sub1
ON sub1.customer_id=c.customer_id
ORDER BY last_name ASC;
  
  -- What is the average payment made by each customer (display the *customer id*, *customer name* (concatenated), 
  -- and the *average payment made*).

#1) Average payment by customer_id from payment table
SELECT customer_id, ROUND(AVG(amount),2) AS ave_payment FROM sakila.payment
GROUP BY customer_id;

#2) Using the previous query as subquery, join tables
SELECT sub1.customer_id, CONCAT(c.first_name," ",c.last_name) AS customer_name, sub1.ave_payment
FROM sakila.customer AS c
JOIN (
SELECT customer_id, ROUND(AVG(amount),2) AS ave_payment FROM sakila.payment
GROUP BY customer_id
) AS sub1 ON sub1.customer_id=c.customer_id
ORDER BY customer_name;

  -- Select the *name* and *email* address of all the customers who have rented the "Action" movies.
  
  -- Write the query using multiple join statements
  -- Write the query using sub queries with multiple WHERE clause and `IN` condition
  -- Verify if the above two queries produce the same results or not

#1) Joins on multiple tables
SELECT r.rental_id, r.customer_id, cat.name AS category FROM sakila.rental AS r
JOIN sakila.inventory AS i ON r.inventory_id=i.inventory_id
JOIN sakila.film AS f ON i.film_id=f.film_id
JOIN sakila.film_category AS fc ON f.film_id=fc.film_id
JOIN sakila.category AS cat ON fc.category_id=cat.category_id;

SELECT CONCAT(c.first_name," ",c.last_name) AS customer_name, c.email FROM sakila.customer AS c
JOIN (
SELECT DISTINCT customer_id FROM (
SELECT r.rental_id, r.customer_id, cat.name AS category FROM sakila.rental AS r
JOIN sakila.inventory AS i ON r.inventory_id=i.inventory_id
JOIN sakila.film AS f ON i.film_id=f.film_id
JOIN sakila.film_category AS fc ON f.film_id=fc.film_id
JOIN sakila.category AS cat ON fc.category_id=cat.category_id
) AS sub1
WHERE category = "Action"
) AS sub2
ON sub2.customer_id=c.customer_id
ORDER BY customer_name ASC;

  -- Use the case statement to create a new column classifying existing columns as either or 
  -- high value transactions based on the amount of payment. 

  -- If the amount is between 0 and 2, label should be `low` and if the amount is between 2 and 4, 
  -- the label should be `medium`, and if it is more than 4, then it should be `high`.

SELECT *, 
CASE 
	WHEN payment.amount < 2 THEN 'low'
	WHEN payment.amount BETWEEN 2 AND 4 THEN 'medium'
    WHEN payment.amount > 4 THEN 'high'
END
AS classification_payment
FROM sakila.payment;
