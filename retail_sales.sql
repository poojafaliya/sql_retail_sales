create database sql_project_p1;
use sql_project_p1;

create table  retail_sales (
transactions_id	 int primary key,
sale_date date,
sale_time time,
customer_id int,
gender varchar(50),
age int,
category varchar(30),
quantiy	int,
price_per_unit float,
cogs float,
total_sale float)



SELECT 
    *
FROM
    sql_project_p1.retail_sales;

SELECT 
    *
FROM
    retail_sales;

-- data cleanning

SELECT 
    *
FROM
    retail_sales
WHERE
    transactions_id IS NULL
        OR sale_date IS NULL
        OR sale_time IS NULL
        OR gender IS NULL
        OR category IS NULL
        OR quantiy IS NULL
        OR cogs IS NULL
        OR total_sale IS NULL;
DELETE FROM retail_sales 
WHERE
    sale_date IS NULL OR sale_time IS NULL
    OR customer_id IS NULL
    OR gender IS NULL
    OR age IS NULL
    OR category IS NULL
    OR quantity IS NULL
    OR price_per_unit IS NULL
    OR cogs IS NULL;


-- data exploration
SELECT 
    COUNT(*) AS total_sale
FROM
    retail_sales;

SELECT 
    COUNT(DISTINCT customer_id) AS total_customer
FROM
    retail_sales;

SELECT DISTINCT
    category
FROM
    retail_sales;
-- data analyze:>

SELECT 
    *
FROM
    retail_sales
WHERE
    sale_date = '2022-11-05';

-- 2. Write a SQL query to retrieve all transactions where 
-- the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022:
 
SELECT 
    *
FROM
    retail_sales
WHERE
    category = 'Clothing'
        AND DATE_FORMAT(sale_date, '%Y-%m') = '2022-11'
        AND quantiy >= 4;
  
-- 3. Write a SQL query to calculate the total sales (total_sale) for each category.:
SELECT 
    category,
    SUM(total_sale) AS net_sale,
    COUNT(*) AS total_order
FROM
    retail_sales
GROUP BY category;

-- 4. Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.:
SELECT 
    ROUND(AVG(age), 2) avg_age
FROM
    retail_sales
WHERE
    category = 'Beauty';

-- 5.  Write a SQL query to find all transactions where the total_sale is greater than 1000.:
SELECT 
    *
FROM
    retail_sales
WHERE
    total_sale > 1000;
-- 6. Write a SQL query to find the total number of
-- transactions (transaction_id) made by each gender in each category.:

SELECT 
    category, gender, COUNT(*) AS total_teands
FROM
    retail_sales
GROUP BY category , gender
ORDER BY category;

--  7. Write a SQL query to calculate the average sale for each month. Find out best selling month in each year:
select year,month,avg_sale from (
SELECT 
    EXTRACT(YEAR FROM sale_date) AS year,
    EXTRACT(MONTH FROM sale_date) AS month,
    ROUND(AVG(total_sale), 2) AS avg_sale,
    rank() over (partition by EXTRACT(YEAR FROM sale_date) order by AVG(total_sale) desc) rnk
FROM retail_sales
GROUP BY year , month
ORDER BY  year ) as t1
where  rnk = 1;

-- 8. Write a SQL query to find the top 5 customers based on the highest total sales **:
SELECT 
    customer_id, SUM(total_sale) AS total_sales
FROM
    retail_sales
GROUP BY customer_id
ORDER BY total_sales DESC
LIMIT 5;

-- 9.Write a SQL query to find the number of unique customers who purchased items from each category.:

SELECT 
    category, COUNT(DISTINCT customer_id) AS cou_unique_cs
FROM
    retail_sales
GROUP BY category;

-- 10. Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17):

with hourly_sales
as
(
select *,
case 
when extract(hour from sale_time) > 12  then "morning"
when extract(hour from sale_time)  between 12 and 17  then "afternoon"
else "evening"
end as shift
from retail_sales)

select  shift, count(*)as total_orders  from hourly_sales
group by shift;


