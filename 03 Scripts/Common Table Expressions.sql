-- step1: Average amount paid by the top 5 customers using CTE

WITH cte_amount_paid
AS
(SELECT A.customer_id, A.first_name, A.last_name, c.city, d.country, SUM(amount) AS total_amount_paid
FROM customer A
INNER JOIN address B ON A.address_id = B.address_id
INNER JOIN city C ON b.city_id = c.city_id
INNER JOIN country D ON c.country_id = d.country_id
INNER JOIN payment E ON A.customer_id = E.customer_id
WHERE c.city IN(SELECT C.city
FROM customer A
INNER JOIN address B ON A.address_id = B.address_id
INNER JOIN city C ON B.city_id = C.city_id
INNER JOIN country D ON C.country_id = D.country_id
WHERE D.country IN
(SELECT D.country
FROM customer A
INNER JOIN address B ON A.address_id = B.address_id
INNER JOIN city C ON B.city_id = C.city_id
INNER JOIN country D ON C.country_id = D.country_id
GROUP BY country
ORDER BY COUNT (customer_id) DESC
LIMIT 10)
GROUP BY D.country, C.city
ORDER BY COUNT (customer_id) DESC
LIMIT 10)
GROUP BY A.customer_id, A.first_name, A.last_name, c.city, d.country
ORDER BY total_amount_paid DESC
LIMIT 5)
SELECT ROUND(AVG(total_amount_paid),2) AS avg_amount_paid
FROM cte_amount_paid;


---To find out how many of the top 5 customers are based within each country. Your final output should include 3 columns: “country”, “all_customer_count” with the total number of customers in each country, and “top_customer_count” showing how many of the top 5 customers live in each country.
---To find that, I used this query

WITH top_customer_count_cte
AS
(SELECT A.customer_id, A.first_name, A.last_name, c.city, d.country, SUM(amount) AS total_amount_paid
FROM customer A
INNER JOIN address B ON A.address_id = B.address_id
INNER JOIN city C ON b.city_id = c.city_id
INNER JOIN country D ON c.country_id = d.country_id
INNER JOIN payment E ON A.customer_id = E.customer_id
WHERE c.city IN(SELECT C.city
FROM customer A
INNER JOIN address B ON A.address_id = B.address_id
INNER JOIN city C ON B.city_id = C.city_id
INNER JOIN country D ON C.country_id = D.country_id
WHERE D.country IN
(SELECT D.country
FROM customer A
INNER JOIN address B ON A.address_id = B.address_id
INNER JOIN city C ON B.city_id = C.city_id
INNER JOIN country D ON C.country_id = D.country_id
GROUP BY country
ORDER BY COUNT (customer_id) DESC
LIMIT 10)
GROUP BY D.country, C.city
ORDER BY COUNT (customer_id) DESC
LIMIT 10)
GROUP BY A.customer_id, A.first_name, A.last_name, c.city, d.country
ORDER BY total_amount_paid DESC
LIMIT 5),
customer_count_cte AS
(SELECT D.country,
COUNT(DISTINCT A.customer_id) AS all_customer_count,
COUNT(DISTINCT D.country) AS top_customer_count




