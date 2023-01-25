/*WS+QS #1_Q1-query used for fisrt insight*/
/*We want to understand more about the movies that families are watching. Animation,
Children, Classics, Comedy, Family and Music are considered as family movies*/

SELECT DISTINCT(film_title), category_name,
COUNT(film_title) over (partition by film_title) as rental_count
	FROM
	(select f.title AS film_title, c.name AS category_name
	FROM film_category fc
	JOIN category c
	ON c.category_id = fc.category_id
	JOIN film f
	ON f.film_id = fc.film_id
	JOIN inventory i
	ON i.film_id = f.film_id
	JOIN rental r
	ON r.inventory_id= i.inventory_id
	WHERE c.name IN ('Animation', 'Classics', 'Children','Comedy','Family','Music')
	) as t1
order by category_name, film_title;


/*WS+QS #1_Q2-query used for second insight*/
/*Now we need to know the length of rental duration in each movie category of these
family-friendly movies.*/

select f.title, c.name, f.rental_duration,
ntile(4) over (order by f.rental_duration) as standard_quartile
from film f
join film_category fc
on f.film_id = fc.film_id
join category c
on fc.category_id = c.category_id
where c.name in ('Animation', 'Classics', 'Children','Comedy','Family','Music');


/*WS+QS #1_Q3-query used for third insight*/
/*We want to know the count of movies within each combination of film
category for each corresponding rental duration category.*/

SELECT "name", standard_quartile, COUNT(*)
	FROM
	(SELECT f.title title, c.name "name", f.rental_duration rental_duration ,
	NTILE(4) over (order by f.rental_duration) as standard_quartile
	FROM film f
	JOIN film_category fc
	ON f.film_id = fc.film_id
	JOIN category c
	ON fc.category_id = c.category_id
	WHERE c.name in ('Animation', 'Classics', 'Children','Comedy','Family','Music')
	) AS t1
GROUP BY name, standard_quartile
ORDER BY 1,2;

/*WS+QS #2_Q1-query used for fourth insight*/
/*We want to find out how the two stores compare in their count of rental
orders during every month for all the years we have data for*/

SELECT  date_part('month', r.rental_date) Rental_month,
date_part('year', r.rental_date) Rental_year,
str.store_id Store_ID,
COUNT(*) Count_rentals
	FROM store str
	JOIN staff stf
	ON str.store_id = stf.store_id
	JOIN rental r
	ON r.staff_id = stf.staff_id
GROUP BY rental_month, Rental_year, str.Store_ID
ORDER BY Count_rentals desc;
