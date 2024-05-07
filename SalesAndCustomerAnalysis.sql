-- CREATING DATABASE --

CREATE DATABASE IF NOT EXISTS shopping_mall_db;
USE shopping_mall_db;




-- CREATING TABLES --

CREATE TABLE IF NOT EXISTS sales_tbl (
	invoice_no VARCHAR(255)
    , customer_id VARCHAR(255)
    , category VARCHAR(255)
    , quantity INT
    , price DECIMAL(10, 2)
    , invoice_date DATE
    , shopping_mall VARCHAR(255)
);

CREATE TABLE IF NOT EXISTS customer_tbl (
	customer_id VARCHAR(255)
    , gender VARCHAR(255)
    , age INT
    , payment_method VARCHAR(255)
);




-- LOADING DATA INTO TABLES --

LOAD DATA INFILE 'D:\\ProgramData\\MySQL\\MySQL Server 8.3\\Uploads\\Sales and Customer dataset\\sales_data.csv'
	INTO TABLE sales_tbl
	FIELDS TERMINATED BY ','
	OPTIONALLY ENCLOSED BY '"'
	LINES TERMINATED BY '\n'
	IGNORE 1 ROWS
	(invoice_no, customer_id, @category, quantity, price, invoice_date, shopping_mall)
	SET category = IF(@category = 'NULL' OR @category = '', NULL, @category);

LOAD DATA INFILE 'D:\\ProgramData\\MySQL\\MySQL Server 8.3\\Uploads\\Sales and Customer dataset\\customer_data.csv'
	INTO TABLE customer_tbl
	FIELDS TERMINATED BY ','
	OPTIONALLY ENCLOSED BY '"'
	LINES TERMINATED BY '\n'
	IGNORE 1 ROWS
	(customer_id, @gender, @age, @payment_method)
	SET gender = IF(@gender = 'NULL' OR @gender = '', NULL, @gender)
		, age = IF(@age = 'NULL' OR @age = '', NULL, cast(@age AS UNSIGNED INTEGER))
		, payment_method = IF(@payment_method = 'NULL' OR @payment_method = '', NULL, @payment_method);




-- EXPLORATORY DATA ANALYSIS --

SELECT * FROM sales_tbl LIMIT 100;
SELECT * FROM customer_tbl LIMIT 100;


-- total revenue of shopping malls

SELECT
	sum(quantity * price) AS total_revenue
FROM sales_tbl;


-- total revenue by shopping malls

SELECT
	shopping_mall
	, sum(quantity * price) AS total_revenue
    , round(sum(quantity * price)/sum(sum(quantity * price)) OVER() * 100, 2) AS revenue_percentage
FROM sales_tbl
GROUP BY 
	shopping_mall
ORDER BY
	total_revenue DESC;
    

-- total revenue by category

SELECT
	category
    , sum(quantity * price) AS total_revenue
    , round(sum(quantity * price)/sum(sum(quantity * price)) OVER() * 100, 2) AS revenue_percentage
FROM sales_tbl
GROUP BY
	category
ORDER BY
	total_revenue DESC;


-- total revenue by gender

SELECT
	c.gender
    , sum(s.quantity * s.price) AS total_revenue
    , round(sum(quantity * price)/sum(sum(quantity * price)) OVER() * 100, 2) AS revenue_percentage
FROM sales_tbl s
	JOIN customer_tbl c ON c.customer_id = s.customer_id
GROUP BY
	c.gender
ORDER BY
	total_revenue DESC;
    

-- total revenue by age

SELECT
	c.age
    , sum(s.quantity * s.price) AS total_revenue
    , round(sum(quantity * price)/sum(sum(quantity * price)) OVER() * 100, 2) AS revenue_percentage
FROM sales_tbl s
	JOIN customer_tbl c ON c.customer_id = s.customer_id
GROUP BY
	c.age
ORDER BY
	total_revenue DESC;
	
	
-- total revenue by payment methods

SELECT
	c.payment_method
    , sum(s.quantity * s.price) AS total_revenue
    , round(sum(quantity * price)/sum(sum(quantity * price)) OVER() * 100, 2) AS revenue_percentage
FROM sales_tbl s
	JOIN customer_tbl c ON c.customer_id = s.customer_id
GROUP BY
	c.payment_method
ORDER BY
	total_revenue DESC;
    

-- avg sales of shoppings malls

SELECT
	sum(quantity * price)/(count(DISTINCT shopping_mall)) AS avg_sales
FROM sales_tbl;


-- avg sales by shopping malls

SELECT
	shopping_mall
	, sum(quantity * price)/(count(DISTINCT invoice_no)) AS avg_sales
FROM sales_tbl
GROUP BY 
	shopping_mall
ORDER BY
	avg_sales DESC;


-- avg sales by category

SELECT
	category
	, sum(quantity * price)/(count(DISTINCT invoice_no)) AS avg_sales
FROM sales_tbl
GROUP BY 
	category
ORDER BY
	avg_sales DESC;


-- avg sales by gender

SELECT
	c.gender
    , sum(s.quantity * s.price)/count(DISTINCT s.invoice_no) AS avg_sales
FROM sales_tbl s
	JOIN customer_tbl c ON c.customer_id = s.customer_id
GROUP BY
	c.gender
ORDER BY
	avg_sales DESC;
    

-- avg sales by age

SELECT
	c.age
    , sum(s.quantity * s.price)/count(DISTINCT s.invoice_no) AS avg_sales
FROM sales_tbl s
	JOIN customer_tbl c ON c.customer_id = s.customer_id
GROUP BY
	c.age
ORDER BY
	avg_sales DESC;
    

-- avg sales by payment method

SELECT
	c.payment_method
    , sum(s.quantity * s.price)/count(DISTINCT s.invoice_no) AS avg_sales
FROM sales_tbl s
	JOIN customer_tbl c ON c.customer_id = s.customer_id
GROUP BY
	c.payment_method
ORDER BY
	avg_sales DESC;


-- yearly sales trend

SELECT
	extract(YEAR FROM invoice_date) AS time
    , sum(quantity * price) AS total_sales
FROM sales_tbl
GROUP BY
	year
ORDER BY
	year DESC;


-- monthly sales trend

SELECT
	date_format(invoice_date, '%Y-%m') AS time
	, sum(quantity * price) AS total_sales
FROM sales_tbl
GROUP BY
	time
ORDER BY
	time DESC;


-- monthly sales trend by shopping mall

SELECT
	date_format(invoice_date, '%Y-%m') AS time
    , s.shopping_mall
    , sum(quantity * price) AS total_sales
    , round(sum(quantity * price)/sum(sum(quantity * price)) OVER(PARTITION BY date_format(invoice_date, '%Y-%m')) * 100, 2) AS sales_percentage
FROM sales_tbl s
	JOIN customer_tbl c ON c.customer_id = s.customer_id
GROUP BY
	time
    , s.shopping_mall
ORDER BY
	time DESC;
    

-- monthly sales trend by gender

SELECT
	date_format(s.invoice_date, '%Y-%m') AS time
    , c.gender
    , sum(s.quantity * s.price) AS total_sales
    , round(sum(quantity * price)/sum(sum(quantity * price)) OVER(PARTITION BY date_format(invoice_date, '%Y-%m')) * 100, 2) AS sales_percentage
FROM sales_tbl s
	JOIN customer_tbl c ON c.customer_id = s.customer_id
GROUP BY
	time
    , c.gender
ORDER BY
	time DESC;


-- monthly sales trend by payment method

SELECT
	date_format(s.invoice_date, '%Y-%m') AS time
    , c.payment_method
    , sum(s.quantity * s.price) AS total_sales
    , round(sum(quantity * price)/sum(sum(quantity * price)) OVER(PARTITION BY date_format(invoice_date, '%Y-%m')) * 100, 2) AS sales_percentage
FROM sales_tbl s
	JOIN customer_tbl c ON c.customer_id = s.customer_id
GROUP BY
	time
    , c.payment_method
ORDER BY
	time DESC;


-- weekly sales by shopping malls

SELECT
	dayname(invoice_date) AS day
    , s.shopping_mall
    , sum(quantity * price) AS total_sales
    , round(sum(quantity * price)/sum(sum(quantity * price)) OVER(PARTITION BY dayname(invoice_date)) * 100, 2) AS sales_percentage
FROM sales_tbl s
	JOIN customer_tbl c ON c.customer_id = s.customer_id
GROUP BY
	dayofweek(s.invoice_date)
	, day
    , s.shopping_mall
ORDER BY
	dayofweek(s.invoice_date) ASC
    , total_sales DESC;
    

-- weekly sales by category

SELECT
	dayname(invoice_date) AS day
    , s.category
    , sum(quantity * price) AS total_sales
    , round(sum(quantity * price)/sum(sum(quantity * price)) OVER(PARTITION BY dayname(invoice_date)) * 100, 2) AS sales_percentage
FROM sales_tbl s
	JOIN customer_tbl c ON c.customer_id = s.customer_id
GROUP BY
	dayofweek(s.invoice_date)
	, day
    , s.category
ORDER BY
	dayofweek(s.invoice_date) ASC
    , total_sales DESC;


-- weekly sales by gender

SELECT
	dayname(invoice_date) AS day
    , c.gender
    , sum(quantity * price) AS total_sales
    , round(sum(quantity * price)/sum(sum(quantity * price)) OVER(PARTITION BY dayname(invoice_date)) * 100, 2) AS sales_percentage
FROM sales_tbl s
	JOIN customer_tbl c ON c.customer_id = s.customer_id
GROUP BY
	dayofweek(s.invoice_date)
	, day
    , c.gender
ORDER BY
	dayofweek(s.invoice_date) ASC
    , total_sales DESC;
    

 -- weekly sales by payment method

SELECT
	dayname(invoice_date) AS day
    , c.payment_method
    , sum(quantity * price) AS total_sales
    , round(sum(quantity * price)/sum(sum(quantity * price)) OVER(PARTITION BY dayname(invoice_date)) * 100, 2) AS sales_percentage
FROM sales_tbl s
	JOIN customer_tbl c ON c.customer_id = s.customer_id
GROUP BY
	dayofweek(s.invoice_date)
	, day
    , c.payment_method
ORDER BY
	dayofweek(s.invoice_date) ASC
    , total_sales DESC;   
    

-- total customers

SELECT
	count(DISTINCT customer_id) AS total_customers
FROM customer_tbl;


-- top 5 customers

SELECT
	s.customer_id
    , c.gender
    , c.age
    , sum(s.quantity * s.price) AS total_purchase
FROM sales_tbl s
    JOIN customer_tbl c ON c.customer_id = s.customer_id
GROUP BY
	s.customer_id
    , c.gender
    , c.age
ORDER BY
	total_purchase DESC
LIMIT 5;


-- bottom 5 customers

SELECT
	s.customer_id
    , c.gender
    , c.age
    , sum(s.quantity * s.price) AS total_purchase
FROM sales_tbl s
    JOIN customer_tbl c ON c.customer_id = s.customer_id
GROUP BY
	s.customer_id
    , c.gender
    , c.age
ORDER BY
	total_purchase ASC
LIMIT 5;	
    

-- customer demographics with their spendings

SELECT 
    c.gender
    , AVG(c.age) AS avg_age
    , COUNT(DISTINCT s.customer_id) AS total_customers
    , SUM(s.quantity * s.price) AS total_spent
FROM sales_tbl s
	JOIN customer_tbl c ON s.customer_id = c.customer_id
GROUP BY 
	c.gender
ORDER BY
	total_spent DESC
    , total_customers DESC;