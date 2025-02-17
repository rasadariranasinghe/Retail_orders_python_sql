DROP TABLE orders
CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    order_date DATE NOT NULL,
    ship_mode VARCHAR(50),
    segment VARCHAR(50),
    country VARCHAR(100),
    city VARCHAR(100),
    state VARCHAR(100),
    postal_code VARCHAR(20),
    region VARCHAR(50),
    category VARCHAR(50),
    sub_category VARCHAR(50),
    product_id VARCHAR(50) NOT NULL,
    quantity INTEGER NOT NULL CHECK (quantity > 0),
    sales_price NUMERIC(10,2),
    profit NUMERIC(12,2)
);

SELECT * FROM orders

--find top ten highest profit generating products
SELECT sub_category, profit
FROM orders
ORDER BY profit DESC 
LIMIT 10;

--find top five highest selling products in each region

WITH ranking_sales AS (
	SELECT region, product_id,
	SUM (sales_price) AS sales,
		RANK () OVER (PARTITION BY region ORDER BY SUM (sales_price) DESC) AS rank
	FROM orders
	GROUP BY region, product_id
	
)
SELECT region, product_id, sales
FROM ranking_sales
WHERE rank<= 5
ORDER BY region, sales DESC

--second method

With ranking_sales AS (
SELECT region, product_id, sum(sales_price) AS sales
FROM orders
GROUP BY region, product_id)
SELECT * from
(SELECT *,RANK() OVER (PARTITION  BY region ORDER BY sales DESC) AS rank
FROM ranking_sales) A
WHERE rank <=5

--find month over month growth comparison for 2022 and 2023 sales

WITH cte AS (
SELECT EXTRACT(YEAR FROM order_date) AS year,
       EXTRACT(MONTH FROM order_date) AS month,
	   SUM(sales_price) AS sales
FROM orders
GROUP BY EXTRACT(YEAR FROM order_date), EXTRACT(MONTH FROM order_date)
)
SELECT month, 
	SUM(case when year =2022 then sales else 0 end) AS sales_2022,
	SUM(case when year =2023 then sales else 0 end) AS sales_2023
From cte
GROUP BY month
ORDER BY month ASC


--for each categoy which month has the highest sales

WITH cte AS(
SELECT category ,
	EXTRACT(YEAR FROM order_date) AS year,
	EXTRACT(MONTH FROM order_date) AS month,
	SUM (sales_price) AS sales
FROM orders
GROUP BY category,month, year
)

SELECT * FROM
(SELECT *, RANK() OVER (PARTITION  BY category ORDER BY sales DESC) AS rank
FROM cte)A
WHERE rank<=1

--SELECT TO_CHAR(order_date, 'YYYY MM') AS Year_month FROM orders;

--second method
WITH cte AS(
SELECT category ,
	TO_CHAR(order_date, 'YYYY MM') AS year_month,
	SUM (sales_price) AS sales
FROM orders
GROUP BY category,year_month
)

SELECT * FROM
(SELECT *, RANK() OVER (PARTITION  BY category ORDER BY sales DESC) AS rank
FROM cte)A
WHERE rank<=1


--which sub- category has the highest growth by profit in 2023 compared to 2022

WITH CTE AS (
SELECT sub_category, SUM(profit) AS Gain, EXTRACT(YEAR FROM order_date) AS year
FROM orders
GROUP BY sub_category,EXTRACT(YEAR FROM order_date) 
),
CTE2 AS (
SELECT sub_category,
	SUM(CASE WHEN year = 2023 THEN gain ELSE 0 END )AS gain_2023,
	SUM(CASE WHEN year = 2022 THEN gain ELSE 0 END )AS gain_2022
FROM CTE
GROUP BY sub_category
)
SELECT * ,
(((gain_2023 - gain_2022)/gain_2022)*100) AS Profit_percentage
FROM CTE2
ORDER BY Profit_percentage DESC
LIMIT 1;







