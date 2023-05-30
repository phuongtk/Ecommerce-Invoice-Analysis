/* Examine distribution of quantity by product */
SELECT description, 
       COUNT(*) AS sample,
	   AVG(quantity) AS mean_q,
	   PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY quantity) AS median_q,
	   stddev(quantity) AS sd_q
FROM invoice_clean
GROUP BY 1
ORDER BY 5 DESC


/* Examine discount */
WITH d AS (
     SELECT *,
            MAX(unit_price) OVER(PARTITION BY stock_code, description) AS og_price,
            (1-(unit_price/(MAX(unit_price) OVER(PARTITION BY stock_code, description))))*100 AS discount
     FROM invoice_clean -- amount of discount received per invoice
)
SELECT i.description, 
       CORR(i.unit_price, i.quantity) AS price_quantity, -- does lower price increase the quantity purchase?
	   d.og_price -- does this correlation change based on original price of the product?
FROM invoice_clean AS i
LEFT JOIN d
ON i.stock_code = d.stock_code
   AND i.description = d.description
GROUP BY 1,3
ORDER BY 2


/* Which months do people start buying for Christmas? */
WITH c AS (
     SELECT EXTRACT(YEAR FROM invoice_date) AS year,
            EXTRACT(MONTH FROM invoice_date) AS month,
	        invoice_no,
	        description,
	        quantity
     FROM invoice_clean
     WHERE description LIKE '%CHRISTMAS%'
     ORDER BY 1, 2
)
SELECT month,
       COUNT(DISTINCT invoice_no) AS orders 
FROM c
WHERE year = 2011
GROUP BY 1
ORDER BY 1 -- distribution of orders of Xmas products by month in 2011 (invoice date in 2010 only has December)


/* Categorise Xmas and regular products */ 
SELECT *,
       CASE WHEN description LIKE '%CHRISTMAS%' THEN 'Christmas'
	        ELSE 'Non-Christmas'
			END AS category
FROM invoice_clean
WHERE EXTRACT(YEAR FROM invoice_date) = 2011


/* Xmas products typically buy together */ 
-- Recode stock_code (because it contains string)
DROP TABLE IF EXISTS xmas;
CREATE TEMP TABLE xmas AS
WITH code AS (
     SELECT stock_code,
            ROW_NUMBER() OVER() AS product_code
     FROM (SELECT DISTINCT stock_code
           FROM invoice_clean
	       WHERE description LIKE '%CHRISTMAS%') AS xmas_p
) -- list of distinct Xmas products recoded
SELECT i.invoice_no,
       i.stock_code,
       c.product_code
FROM invoice_clean AS i
LEFT JOIN code AS c
ON i.stock_code = c.stock_code
WHERE description LIKE '%CHRISTMAS%'

-- Create unique pairs of Xmas products & count how many times they appear in 1 invoice
SELECT a.stock_code,
       b.stock_code,
	   COUNT(*)
FROM xmas AS a
INNER JOIN
xmas AS b
ON a.invoice_no = b.invoice_no
AND a.product_code <> b.product_code
AND a.product_code < b.product_code
GROUP BY 1,2
ORDER BY 3 DESC, 1


/* Popularity of regular products */ 
-- Find regular products where avg Xmas orders > 2*avg monthly order (popularity based on orders)
CREATE TEMP TABLE orderx AS
WITH nonxmas AS (
	 SELECT *,
            EXTRACT(MONTH FROM invoice_date) AS month
     FROM invoice_clean
     WHERE EXTRACT(YEAR FROM invoice_date) = 2011
     AND description NOT LIKE '%CHRISTMAS%' -- table of regular products in 2011
),
     x AS (
	 SELECT description,
		    (COUNT(DISTINCT invoice_no))/3 AS xmas_orders
	 FROM nonxmas
	 WHERE month BETWEEN 9 AND 11
	 GROUP BY 1 -- calculate average orders in 3 Xmas months
)
SELECT n.description,
       (COUNT(DISTINCT n.invoice_no))/12 AS avg_monthly_orders,
	   x.xmas_orders,
	   CASE WHEN (COUNT(DISTINCT n.invoice_no))/12 < x.xmas_orders/2 
	        THEN 'yes'
	        ELSE 'no' 
			END AS popular_in_xmas
FROM nonxmas AS n
LEFT JOIN x
ON n.description = x.description
GROUP BY 1,3

-- Find regular products where avg Xmas customers > 2*avg monthly customers (popularity based on customers)
CREATE TEMP TABLE custx AS
WITH nonxmas AS (
	 SELECT *,
            EXTRACT(MONTH FROM invoice_date) AS month
     FROM invoice_clean
     WHERE EXTRACT(YEAR FROM invoice_date) = 2011
     AND description NOT LIKE '%CHRISTMAS%'
),
     x AS (
	 SELECT description,
		    (COUNT(DISTINCT customer_id))/3 AS xmas_cust
	 FROM nonxmas
	 WHERE month BETWEEN 9 AND 11
	 GROUP BY 1
)
SELECT n.description,
       (COUNT(DISTINCT n.customer_id))/12 AS avg_monthly_cust,
	   x.xmas_cust,
	   CASE WHEN (COUNT(DISTINCT n.customer_id))/12 < x.xmas_cust/2 
	        THEN 'yes'
	        ELSE 'no' 
			END AS popular_in_xmas
FROM nonxmas AS n
LEFT JOIN x
ON n.description = x.description
GROUP BY 1,3

-- Join tables to see popularity of regular products in 3 perspectives (based on order, on customer, on both)
SELECT o.description,
       o.popular_in_xmas AS order_popular,
	   c.popular_in_xmas AS cust_popular,
	   CASE WHEN o.popular_in_xmas = 'yes' AND c.popular_in_xmas = 'yes'
	        THEN 'yes'
			ELSE 'no' END AS both_popular
FROM orderx AS o
FULL JOIN custx AS c
ON o.description = c.description
ORDER BY 1


/* Trends in popular vs unpopular regular products for Xmas */
-- Finalised list of regular products popular for Xmas
CREATE TEMP TABLE reg_pop AS
SELECT description 
FROM orderx
WHERE popular_in_xmas = 'yes'
AND description <> 'ENAMEL BOWL PANTRY'
AND description <> 'GREEN METAL BOX ARMY SUPPLIES'
AND description <> 'PAPER LANTERN 6 POINT SNOW STAR'
AND description <> 'PAPER LANTERN 5 POINT STAR MOON'
AND description <> 'PAPER LANTERN 9 POINT HOLLY STAR 40'
AND description <> 'RUSTIC STRAWBERRY JAM POT LARGE'
AND description <> 'RUSTIC STRAWBERRY JAM POT SMALL'
AND description <> 'SPACE BOY CHILDRENS CUP' -- filter out based on visualisation in Tableau

-- How many times do WALL ART appear in the list of popular vs unpopular regular products for Xmas?
SELECT description,
       CASE WHEN description LIKE '%WALL%ART%' THEN 'Wall art products'
	        ELSE 'Other products' END AS type,
	   CASE WHEN description IS NOT NULL THEN 'Popular'
	        END AS during_xmas	
FROM reg_pop -- categorise WALL ART products in list of popular products
UNION
SELECT description,
       CASE WHEN description LIKE '%WALL%ART%' THEN 'Wall art products'
	        ELSE 'Other products' END AS type,
	   CASE WHEN description IS NOT NULL THEN 'Unpopular'
	        END AS during_xmas	
FROM (SELECT description
     FROM orderx
     EXCEPT
     SELECT *
     FROM reg_pop) AS reg_unpop -- categorise WALL ART products in list of unpopular products