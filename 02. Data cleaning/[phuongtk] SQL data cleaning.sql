/* Removing null, unrelevant values & Standardising description */

DROP TABLE IF EXISTS invoice_1;
CREATE TEMP TABLE invoice_1 AS 
SELECT invoice_no,
       stock_code,
	   UPPER(TRIM(description)) AS product_description, -- capitalise letters & remove extra blank space
	   quantity,
	   invoice_date,
	   unit_price,
	   customer_id,
	   country
FROM invoice
WHERE customer_id IS NOT NULL
AND country IS NOT NULL 
AND country <> 'Unspecified'
AND quantity > 0 
AND stock_code NOT IN 
    ('POST', 'PADS', 'M', 'DOT', 'C2', 'BANK CHARGES'); -- filter out irrelevant product code


/* Matching each stock code with 1 product description */

DROP TABLE IF EXISTS invoice_2;
CREATE TEMP TABLE invoice_2 AS
WITH dup_d AS (
     SELECT stock_code, COUNT(DISTINCT product_description)
     FROM invoice_1
     GROUP BY 1
     HAVING COUNT(DISTINCT product_description) > 1 -- list stock code with variations of description in cte
),
     stan_d AS (
     SELECT stock_code, 
            product_description,
	        ROW_NUMBER() OVER(PARTITION BY stock_code ORDER BY product_description) AS row_num
		    -- use window function to assign variations to unique identifier
     FROM invoice_1
     WHERE stock_code IN
           (SELECT stock_code
	        FROM dup_d)
     ORDER BY 1, 2 
)
SELECT invoice_1.invoice_no,
       invoice_1.stock_code,
	   CASE WHEN invoice_1.product_description <> stan_d.product_description 
	        THEN stan_d.product_description
	        ELSE stan_d.product_description
	        END AS description, -- transform all variations into 1 description for each stock code
	   invoice_1.quantity,
	   invoice_1.invoice_date,
	   invoice_1.unit_price,
	   invoice_1.customer_id,
	   invoice_1.country
FROM invoice_1
LEFT JOIN stan_d
          ON invoice_1.stock_code = stan_d.stock_code 
		  -- left join to keep records from original table and update description
WHERE stan_d.row_num = 1
ORDER BY 1; 


/* Correcting typo in standardised description */
SELECT DISTINCT description
FROM invoice_2
ORDER BY 1; -- examine description

UPDATE invoice_2
SET description = REPLACE(description, '  ', ' ')
WHERE description LIKE '%  %'; -- remove duplicate blank space

UPDATE invoice_2
SET description = REPLACE(description, ' , ', ' ')
WHERE description LIKE '% , %'; -- remove extra comma

UPDATE invoice_2
SET description = 'ACRYLIC JEWEL SNOWFLAKE PINK'
WHERE description = 'ACRYLIC JEWEL SNOWFLAKE,PINK';

UPDATE invoice_2
SET description = 'WALL ART PUDDINGS'
WHERE description = 'WALL ART ,PUDDINGS';


/* Removing duplicates */

DROP TABLE IF EXISTS invoice_3;
CREATE TEMP TABLE invoice_3 AS
WITH dup AS (
	 SELECT *,
            ROW_NUMBER() OVER(PARTITION BY invoice_no, 
						                   stock_code,
							               description,
						                   quantity, 
						                   invoice_date,
							               unit_price,
						                   customer_id, 
						                   country) AS row_num
	        -- use window function to number the times each record appear
     FROM invoice_2
)
SELECT invoice_no, 
	   stock_code,
	   description,
	   quantity, 
	   invoice_date,
	   unit_price,
	   customer_id, 
	   country 
FROM dup
WHERE row_num > 1 -- table containing records that appear more than once in original table
UNION
SELECT *
FROM invoice_2; -- union with original table to remove duplicates


/* 
Conclusion: 
The final cleaned data set is contained in temp table invoice_3 
*/

DROP TABLE IF EXISTS invoice_clean;
CREATE TABLE invoice_clean AS
SELECT * FROM invoice_3;