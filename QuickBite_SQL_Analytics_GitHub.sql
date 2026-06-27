/****************************************************************************************
 Project      : QuickBite SQL Analytics
 Author       : Kiran Thopte
 Database     : MySQL 8.0.46

 Description
 -----------
 This repository contains advanced business analytics SQL solutions for the QuickBite
 food delivery dataset. Queries demonstrate production-style SQL using CTEs, Window
 Functions, Aggregations, Date Functions, RFM Analysis, Cohort Analysis, Pareto Analysis,
 and Query Optimization with Indexes.

****************************************************************************************/

-- QuickBite Express - Crisis Recovery Analysis
-- Table Setup Script
-- Tool: MySQL
-- Analyst: Kiran Thopte
CREATE DATABASE IF NOT EXISTS quickbite_db;
USE quickbite_db;

CREATE TABLE dim_customer (
    customer_id         VARCHAR(20),
    signup_date         VARCHAR(20),
    city                VARCHAR(50),
    acquisition_channel VARCHAR(50)
);

CREATE TABLE dim_restaurant (
    restaurant_id     VARCHAR(20),
    restaurant_name   VARCHAR(100),
    city              VARCHAR(50),
    cuisine_type      VARCHAR(50),
    partner_type      VARCHAR(50),
    avg_prep_time_min VARCHAR(20),
    is_active         VARCHAR(5)
);

CREATE TABLE dim_delivery_partner (
    delivery_partner_id VARCHAR(20),
    partner_name        VARCHAR(100),
    city                VARCHAR(50),
    vehicle_type        VARCHAR(20),
    employment    VARCHAR(20),
    avg_rating          FLOAT,
    is_active           VARCHAR(5)
);

CREATE TABLE dim_menu_item (
    menu_item_id  VARCHAR(20),
    restaurant_id VARCHAR(20),
    item_name     VARCHAR(100),
    category      VARCHAR(50),
    is_veg        VARCHAR(5),
    price         FLOAT
);

CREATE TABLE fact_orders (
    order_id            VARCHAR(20),
    customer_id         VARCHAR(20),
    restaurant_id       VARCHAR(20),
    delivery_partner_id VARCHAR(20),
    order_timestamp     DATETIME,
    subtotal_amount     FLOAT,
    discount_amount     FLOAT,
    delivery_fee        FLOAT,
    total_amount        FLOAT,
    is_cod              VARCHAR(5),
    is_cancelled        VARCHAR(5)
);

CREATE TABLE fact_order_items (
    order_id      VARCHAR(20),
    item_id       VARCHAR(20),
    menu_item_id  VARCHAR(20),
    restaurant_id VARCHAR(20),
    quantity      INT,
    unit_price    FLOAT,
    item_discount FLOAT,
    line_total    FLOAT
);

CREATE TABLE fact_ratings (
    order_id         VARCHAR(20),
    customer_id      VARCHAR(20),
    restaurant_id    VARCHAR(20),
    rating           FLOAT,
    review_text      TEXT,
    review_timestamp VARCHAR(30),
    sentiment_score  FLOAT
);

CREATE TABLE fact_delivery_performance (
    order_id                    VARCHAR(20),
    actual_delivery_time_mins   INT,
    expected_delivery_time_mins INT,
    distance_km                 FLOAT
);

SHOW VARIABLES LIKE 'local_infile';
SET GLOBAL local_infile = 1;
SHOW VARIABLES LIKE "secure_file_priv";

CREATE INDEX idx_orders_customer_date
ON fact_orders(customer_id,order_timestamp);

CREATE INDEX idx_orders_restaurant_date
ON fact_orders(restaurant_id,order_timestamp);

DROP INDEX idx_orders_cancelled ON fact_orders;  

CREATE INDEX idx_orderitems_order
ON fact_order_items(order_id);

CREATE INDEX idx_ratings_restaurant
ON fact_ratings(restaurant_id);

CREATE INDEX idx_delivery_order
ON fact_delivery_performance(order_id);

CREATE INDEX idx_orders_cancelled_date
ON fact_orders(is_cancelled, order_timestamp);
 
/*Find the Top 3 restaurants by revenue in every city during the last 6 months. Ignore cancelled orders*/
WITH revenue_cte AS
(
SELECT
dr.city,
fo.restaurant_id,
dr.restaurant_name,
ROUND(SUM(fo.total_amount),2) revenue,
COUNT(*) total_orders
FROM fact_orders fo
JOIN dim_restaurant dr
ON fo.restaurant_id=dr.restaurant_id
WHERE fo.is_cancelled='N'
AND fo.order_timestamp >= DATE_SUB(
    (SELECT MAX(order_timestamp)
     FROM fact_orders),
    INTERVAL 6 MONTH)
GROUP BY
dr.city,
fo.restaurant_id,
dr.restaurant_name
)      
SELECT *
FROM
(
SELECT *,
DENSE_RANK() OVER(
PARTITION BY city
ORDER BY revenue DESC,total_orders DESC
) rnk
FROM revenue_cte
)x
WHERE rnk<=3; 


/*Identify the Top 10 customers contributing the highest revenue in every acquisition channel*/
WITH customer_revenue AS
(
SELECT
dc.acquisition_channel,
dc.customer_id,
ROUND(SUM(fo.total_amount),2) revenue
FROM fact_orders fo
JOIN dim_customer dc
ON fo.customer_id=dc.customer_id
WHERE fo.is_cancelled='N'
GROUP BY
dc.acquisition_channel,
dc.customer_id
)
SELECT *
FROM
(
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY acquisition_channel
ORDER BY revenue DESC
) rn
FROM customer_revenue
)x
WHERE rn<=10;


/*Find restaurants whose revenue has grown continuously for the last three months*/
WITH monthly_sales AS
(
SELECT
    restaurant_id,
    STR_TO_DATE(DATE_FORMAT(order_timestamp,'%Y-%m-01'),'%Y-%m-%d') AS sales_month,
    ROUND(SUM(total_amount),2) revenue
FROM fact_orders
WHERE is_cancelled='N'
GROUP BY 
    restaurant_id,
    sales_month
),

growth AS
(
SELECT
    *,
    LAG(sales_month,1) OVER(
        PARTITION BY restaurant_id
        ORDER BY sales_month
    ) prev_month,

    LAG(sales_month,2) OVER(
        PARTITION BY restaurant_id
        ORDER BY sales_month
    ) prev2_month,

    LAG(revenue,1) OVER(
        PARTITION BY restaurant_id
        ORDER BY sales_month
    ) prev1,

    LAG(revenue,2) OVER(
        PARTITION BY restaurant_id
        ORDER BY sales_month
    ) prev2

FROM monthly_sales
)
SELECT *
FROM growth
WHERE
TIMESTAMPDIFF(MONTH, prev_month, sales_month)=1
AND TIMESTAMPDIFF(MONTH, prev2_month, prev_month)=1
AND revenue>prev1
AND prev1>prev2;


WITH monthly_sales AS
(
SELECT
restaurant_id,
DATE_FORMAT(order_timestamp,'%Y-%m-01') sales_month,
ROUND(SUM(total_amount),2) revenue
FROM fact_orders
WHERE is_cancelled='N'
GROUP BY
restaurant_id,
sales_month
),
growth AS
(SELECT *,
LAG(revenue,1) OVER(PARTITION BY restaurant_id ORDER BY sales_month) prev1,
LAG(revenue,2) OVER(PARTITION BY restaurant_id ORDER BY sales_month) prev2
FROM monthly_sales
)
SELECT *
FROM growth
WHERE revenue>prev1
AND prev1>prev2;
          
SHOW INDEX FROM fact_orders;
SHOW KEYS FROM fact_orders;  
 
/*Calculate rolling 30-day AVG revenue for every restaurant*/
SELECT restaurant_id,
DATE(order_timestamp) sales_date,
ROUND(SUM(total_amount),2) revenue,
ROUND(AVG(SUM(total_amount))
OVER
(PARTITION BY restaurant_id
ORDER BY DATE(order_timestamp)
RANGE BETWEEN INTERVAL 30 DAY PRECEDING
      AND INTERVAL 1 DAY PRECEDING
),2) rolling_30_day_Avg_revenue
FROM fact_orders
WHERE is_cancelled='N'
GROUP BY
restaurant_id,
DATE(order_timestamp); 
    
/*Identify customers who ordered from at least five different cuisine types.*/
SELECT 
    fo.customer_id
FROM
    fact_orders fo
        JOIN
    dim_restaurant dr ON fo.restaurant_id = dr.restaurant_id
WHERE
    fo.is_cancelled = 'N'
GROUP BY fo.customer_id
HAVING COUNT(DISTINCT dr.cuisine_type) >= 5;
    
/*Identify customers who have not ordered for more than 2 months*/
SELECT
    customer_id,
    DATE(MAX(order_timestamp)) AS last_order_date,
    DATEDIFF(
        (SELECT DATE(MAX(order_timestamp)) FROM fact_orders),
        DATE(MAX(order_timestamp))
    ) AS days_since_last_order
FROM fact_orders
WHERE is_cancelled = 'N'
GROUP BY customer_id
HAVING days_since_last_order > 60
ORDER BY days_since_last_order ASC;
   
/*Find restaurants with the highest cancellation percentage*/
SELECT 
    restaurant_id,
    ROUND(100 * SUM(is_cancelled = 'Y') / COUNT(*),2) AS cancellation_rate
FROM
    fact_orders
GROUP BY restaurant_id
ORDER BY cancellation_rate DESC
LIMIT 150;
   
/*Find customers whose average order value is above the city average.*/ 
with customer_avg as 
(select fo.customer_id, dc.city,round(avg(fo.total_amount),2) as avg_order
from fact_orders fo
join dim_customer dc
on fo.customer_id=dc.customer_id
where fo.is_cancelled="N"
Group by fo.customer_id, dc.city),
cte as
(select customer_id, city, avg_order,
        round(avg(avg_order) over (partition by city),2) as city_avg_order
 from customer_avg)
select * from cte
where avg_order>city_avg_order;

/*Find the highest-selling menu item for every restaurant*/
with cte as
(select restaurant_id,menu_item_id,sum(quantity) as Qty
from fact_order_items
Group by restaurant_id,menu_item_id)
select * from
(select *,row_number() over (partition by restaurant_id order by Qty desc) as RN
from cte) x
where RN=2;  

/*Find customers who has not ordered for last 30 days*/ 
WITH latest_order AS (
    SELECT date(MAX(order_timestamp)) AS max_order_date
    FROM fact_orders
    WHERE is_cancelled = 'N')
SELECT
    dc.customer_id,
    date(MAX(fo.order_timestamp)) AS last_order_date
FROM dim_customer dc
LEFT JOIN fact_orders fo
    ON dc.customer_id = fo.customer_id
    AND fo.is_cancelled = 'N'  
GROUP BY dc.customer_id
HAVING date(MAX(fo.order_timestamp)) IS NULL
    OR date(MAX(fo.order_timestamp)) <= (select max_order_date from latest_order) - INTERVAL 30 DAY;
    
SELECT VERSION();  
 
/*Calculate monthly cohort retention by measuring how many customers returned in Month 1, Month 2, Month 3, etc., after their first purchase.*/
with cte as
(select customer_id,date_format(min(order_timestamp),"%Y-%m-01") as first_purchase
from fact_orders
where is_cancelled="N"
Group by customer_id),
cohort_month as (
select distinct fo.customer_id,c.first_purchase,
       timestampdiff(Month,c.first_purchase,date_format(order_timestamp,"%Y-%m-01")) as month_number
from fact_orders fo
join cte c on fo.customer_id=c.customer_id
and fo.is_cancelled="N")
select first_purchase,month_number,count(distinct customer_id) as retained_customers from cohort_month
Group by 1,2
Order by 1,2;
       

/*Identify customers who have not placed any order in the last 90 days.*/
with cte as
(select date(max(order_timestamp)) as end_date 
from fact_orders 
where is_cancelled="N")

select dc.customer_id, date(max(fo.order_timestamp)) as last_order_date
from dim_customer dc
left join fact_orders fo 
on dc.customer_id=fo.customer_id 
and fo.is_cancelled="N"
Group by dc.customer_id
Having date(max(fo.order_timestamp)) is null
OR date(max(fo.order_timestamp))<=(select end_date from cte)-interval 90 day;

/*Assign every customer an RFM score using Recency, Frequency, and Monetary value.*/
with cte as
(select date(max(order_timestamp)) as end_date 
from fact_orders 
where is_cancelled="N"),
cte2 as (
select fo.customer_id, 
datediff((select end_date from cte),date(max(fo.order_timestamp))) as recency,
count(*) as frequency,
sum(fo.total_amount) as Monetary
from fact_orders fo
where is_cancelled="N"
Group by fo.customer_id)
select customer_id,
ntile(5) over (order by recency desc) R,
ntile(5) over (order by frequency) F,
ntile(5) over (order by Monetary) M
from cte2; 
 
/*Pareto Analysis (80/20 Rule)
Find customers responsible for the first 80% of total revenue
*/ 
with revenue_ as (
select customer_id,round(sum(total_amount),2) as revenue
from fact_orders
where is_cancelled="N"
Group by customer_id),
cumulative_revenue_ as (
select customer_id,revenue,
ROUND(sum(revenue) over (order by revenue desc),2) as cumulative_revenue,
ROUND(sum(revenue) over (),2) as total_revenue
from revenue_)
select * from cumulative_revenue_
where cumulative_revenue<=0.80*total_revenue;

/*Revenue Leakage Due to Discounts
Find the top 20 active restaurants in every city that give the highest average discount (weighted by sales)
*/ 
WITH cte AS (
    SELECT
        fo.restaurant_id,
        dr.city,
        ROUND(SUM(fo.subtotal_amount), 2) AS gross,
        ROUND(
            100 * SUM(fo.discount_amount) /
            NULLIF(SUM(fo.subtotal_amount), 0),
            2
        ) AS discount_pct
    FROM fact_orders fo
    JOIN dim_restaurant dr
        ON dr.restaurant_id = fo.restaurant_id
    WHERE fo.is_cancelled = 'N'
      AND dr.is_active = 'Y'
    GROUP BY
        fo.restaurant_id,
        dr.city
)
SELECT *
FROM (
    SELECT
        *,
        DENSE_RANK() OVER (
            PARTITION BY city
            ORDER BY discount_pct DESC
        ) AS rnk
    FROM cte
) t
WHERE rnk <= 20
ORDER BY city, rnk, discount_pct DESC; 
