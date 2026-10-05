--- Crate databse
create database Retail_Sales;
use Retail_Sales;

--- Create table
create table if not exists retail_sales(
	transaction_id INT,
    sales_date DATE,
    sales_time TIME,
    customer_ID INT,
    gender varchar(15),
    age INT,
    category varchar(15),
    quantity INT,
    price_per_unit float,
    cogs float,
    total_sale float
);

select *  from retail_sales
limit 10;

select count(*)from retail_sales;

select *
from retail_sales
where transaction_id is NULL;

select count(*)
from retail_sales
where age is NULL;

--- Check NULL values
select * from retail_sales
where 
	transaction_id is NULL
	OR
    sales_date is NULL
    OR
    sales_time is NULL
    OR
    customer_ID is NULL
    OR
    gender is NULL
    OR
    age is NULL
    OR
    category is NULL
    OR
    quantity is NULL
    OR
    price_per_unit is NULL
    OR
    cogs is NULL
    OR
    total_sale is NULL;
    
--- DELETE FROM retail_SALES where total_sales IS NULL;

--- Data Exploration
--- How many sales?
select count(*) as total_sale from retail_sales;

--- How many customers?
select count(distinct(customer_ID)) as total_customer from retail_sales;

select distinct category from retail_sales;
    
--- Key problems
-- Q.1 Write a SQL query to retrieve all columns for sales made on 2022-11-05,

select * from retail_sales
where sales_date = '2022-11-05';

-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10,
      
SELECT * from retail_sales
where category = "Clothing" AND quantity <10;

-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.

select category, sum(total_sale) as Total_sale, count(*) as total_orders
from retail_sales
group by category;

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.

select round(avg(age),2) as Avg_age, count(*)
from retail_sales
where category = "Beauty";

-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.

SELECT * 
from retail_sales
where total_sale>1000;

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.

select category, count(*) as total_transaction, gender
from retail_sales
group by category, gender;

-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year

WITH monthly_avg AS (
    select 
        YEAR(sales_date)  AS yr,
        MONTH(sales_date) AS mth,
        AVG(total_sale)  AS avg_sale
    from retail_sales
    group by YEAR(sales_date), MONTH(sales_date)
),
ranked AS (
   select *,
           RANK() OVER (PARTITION BY yr ORDER BY avg_sale DESC) AS rnk
   from monthly_avg
)
select yr, mth, ROUND(avg_sale, 2) AS avg_sale
from ranked
where rnk = 1
ORDER BY yr;
    
-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 

select sum(total_sale) as Total_sale, customer_id, count(*)
from retail_sales
group by customer_id
order by Total_sale desc
limit 5; 

-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.

select category,COUNT(DISTINCT customer_id) AS unique_customers
from retail_sales
group by category
order by unique_customers DESC;

-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)

WITH hourly_sale AS (
    select *,
        CASE
            WHEN HOUR(sales_time) < 12 THEN 'Morning'
            WHEN HOUR(sales_time) BETWEEN 12 AND 17 THEN 'Afternoon'
            ELSE 'Evening'
        END AS shift
    from retail_sales
)
select 
    shift,
    count(*) AS total_orders
from hourly_sale
group by shift
order by total_orders DESC;

