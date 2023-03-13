---Find the average amount paid by the top 5 customers.
--Find out how many of the top 5 customers are based within each country
-----Your final output should include 3 columns:
----country
---all_customer_count* with the total number of customers in each country
----top_customer_count* showing how many of the top 5 customers live in each country

SELECT (D.country),
       COUNT(DISTINCT A.customer_id)AS all_customer_count,
       COUNT(DISTINCT top_5_customers.customer_id)AS top_customer_count
FROM customer A 
INNER JOIN address B ON A.address_id = B.address_id
INNER JOIN city C ON B.city_id = C.city_id
INNER JOIN country D ON C.country_id = D.country_id     
LEFT JOIN
          (SELECT (A.customer_id),(A.first_name),(A.last_name),(D.country), (C.city),  
           SUM (E.amount) AS Total_Amount_Paid
FROM customer A 
INNER JOIN address B ON A.address_id = B.address_id
INNER JOIN city C ON B.city_id = C.city_id
INNER JOIN country D ON C.country_id = D.country_id
INNER JOIN payment E ON A.customer_id = E.customer_id
WHERE C.city IN (SELECT C.city
FROM customer A
INNER JOIN address B ON A.address_id = B.address_id
INNER JOIN city C ON B.city_id = C.city_id
INNER JOIN country D ON C.country_id = D.country_id
WHERE D.country IN (SELECT (D.country)
FROM customer A
INNER JOIN address B ON A.address_id = B.address_id
INNER JOIN city C ON B.city_id = C.city_id
INNER JOIN country D ON C.country_id = D.country_id
GROUP BY country
ORDER BY COUNT (customer_id) Desc
LIMIT 10)
GROUP BY D.country,C.city
ORDER BY COUNT (customer_id) Desc
LIMIT 10)			  
GROUP BY D.country,C.city, first_name, last_name, A.customer_id 
ORDER BY Total_Amount_Paid Desc
LIMIT 5) AS top_5_customers ON D.country = top_5_customers.country
GROUP BY D.country, top_5_customers.country
ORDER BY top_customer_count DESC
LIMIT 5


