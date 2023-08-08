/* Assign recency score to each distinct customer */
DROP TABLE IF EXISTS rec;
CREATE TEMPORARY TABLE rec AS
WITH r AS (
SELECT customer_id,
       DATEDIFF(CURRENT_TIMESTAMP, MAX(invoice_date)) AS recency -- how many days from today to last purchase
FROM invoice_clean
GROUP BY 1
)
SELECT *,
	   CASE WHEN PERCENT_RANK() OVER(ORDER BY recency DESC) <= 0.2 THEN 1  -- top 20% most recent
       WHEN PERCENT_RANK() OVER(ORDER BY recency DESC) > 0.2 
            AND PERCENT_RANK() OVER(ORDER BY recency DESC) <= 0.4 THEN 2
	   WHEN PERCENT_RANK() OVER(ORDER BY recency DESC) > 0.4 
            AND PERCENT_RANK() OVER(ORDER BY recency DESC) <= 0.6 THEN 3
       WHEN PERCENT_RANK() OVER(ORDER BY recency DESC) > 0.6 
            AND PERCENT_RANK() OVER(ORDER BY recency DESC) <= 0.8 THEN 4
	   ELSE 5 END AS r_score
FROM r
ORDER BY 3;

/* Assign frequency score to each distinct customer */
DROP TABLE IF EXISTS fre;
CREATE TEMPORARY TABLE fre AS
WITH f AS (
SELECT customer_id,
       COUNT(DISTINCT invoice_no) AS frequency -- number of distinct orders from each customer
FROM invoice_clean
GROUP BY 1
)
SELECT *,
       CASE WHEN PERCENT_RANK() OVER(ORDER BY frequency) <= 0.2 THEN 1 -- top 20% with most orders
       WHEN PERCENT_RANK() OVER(ORDER BY frequency) > 0.2 
            AND PERCENT_RANK() OVER(ORDER BY frequency) <= 0.4 THEN 2
	   WHEN PERCENT_RANK() OVER(ORDER BY frequency) > 0.4 
            AND PERCENT_RANK() OVER(ORDER BY frequency) <= 0.6 THEN 3
       WHEN PERCENT_RANK() OVER(ORDER BY frequency) > 0.6 
            AND PERCENT_RANK() OVER(ORDER BY frequency) <= 0.8 THEN 4
	   ELSE 5 END AS f_score
FROM f
ORDER BY 3 DESC, 2 DESC;

/* Assign monetary score to each distinct customer */
DROP TABLE IF EXISTS mon;
CREATE TEMPORARY TABLE mon AS
WITH m AS (
SELECT customer_id,
	   CAST(quantity AS DECIMAL) * unit_price AS revenue -- calculate total spending from each customers
FROM invoice_clean
GROUP BY 1
)
SELECT *,
       CASE WHEN PERCENT_RANK() OVER(ORDER BY revenue) <= 0.2 THEN 1 -- top 20% most spent
       WHEN PERCENT_RANK() OVER(ORDER BY revenue) > 0.2 
            AND PERCENT_RANK() OVER(ORDER BY revenue) <= 0.4 THEN 2
	   WHEN PERCENT_RANK() OVER(ORDER BY revenue) > 0.4 
            AND PERCENT_RANK() OVER(ORDER BY revenue) <= 0.6 THEN 3
       WHEN PERCENT_RANK() OVER(ORDER BY revenue) > 0.6 
            AND PERCENT_RANK() OVER(ORDER BY revenue) <= 0.8 THEN 4
	   ELSE 5 END AS m_score
FROM m
ORDER BY 3 DESC, 2 DESC;

/* Summarise table and categorise customers */
WITH rfm AS (
SELECT rec.customer_id,
       CONCAT(rec.r_score, ',', fre.f_score, ',', mon.m_score) AS rfm_cell,
       rec.r_score AS r,
       fre.f_score AS f,
       mon.m_score AS m,
       (rec.r_score + fre.f_score + mon.m_score)/3 AS rfm_score
FROM rec
JOIN fre
ON rec.customer_id = fre.customer_id
JOIN mon
ON fre.customer_id = mon.customer_id
)
SELECT *,
       CASE WHEN r <= 2 AND f = 5 THEN 'Cant lose them'
            WHEN r <= 2 AND f IN (3,4) THEN 'At risks'
            WHEN r <= 2 AND f <= 2 THEN 'Hibernating'
            WHEN r = 3 AND f = 3 THEN 'Need attention'
            WHEN r = 3 AND f <= 2 THEN 'About to Sleep'
            WHEN r = 4 AND f = 1 THEN 'Promising'
            WHEN r IN (3,4) AND  f >= 4 THEN 'Loyal Customers'
            WHEN r = 5 AND f >= 4 THEN 'Champions'
            WHEN r >= 4 AND f IN (2,3) THEN 'Potential Loyalists'
            WHEN r = 5 AND f = 1 THEN 'New Customers'
	  END AS segment
FROM rfm
