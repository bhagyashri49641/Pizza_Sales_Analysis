show databases;
Use pizzasales;
select * from pizza_sales_excel_file;
select *  from pizza_sales_excel_file limit 1000;

-- KPI's
-- 1. total revenue
select sum(total_price) as total_revenue from pizza_sales_excel_file; 
-- op : 817860.049999993

-- 2. Average order value
select sum(total_price)/count(distinct order_id) as avg_order_value from pizza_sales_excel_file;
-- 38.307262295081635

-- 3. Total Pizzas sold
select sum(quantity) as total_pizza_sold from pizza_sales_excel_file;
-- 49574

-- 4. Total orders
select count(distinct order_id) as total_orders from pizza_sales_excel_file;
-- 21350

-- 5. average pizza per order
select cast(cast(sum(quantity) as decimal(10,2))/cast(count(distinct order_id) as decimal(10,2)) as decimal(10,2)) as average_pizzas_per_order from pizza_sales_excel_file;
-- 2.32

-- ***************************************************** Chart requirement **********************************************************
-- 1.Daily trend for total orders
-- added new weekday colm for future
ALTER TABLE pizza_sales_excel_file
ADD weekday VARCHAR(30);

UPDATE pizza_sales_excel_file
SET weekday = DAYNAME(DATE_FORMAT(STR_TO_DATE(order_date, '%d-%m-%Y'), '%Y-%m-%d'))
WHERE order_date IS NOT NULL;

 -- daily trend query
 
SELECT  weekday as order_day, COUNT(DISTINCT ORDER_ID) as total_orders
FROM pizza_sales_excel_file
group by weekday;   -- WORKING

-- 2. Monthly trend for total orders  
-- added new column with ddmmyyyy format
select * from pizza_sales_excel_file;
ALTER TABLE pizza_sales_excel_file
ADD new_order_date DATE;
UPDATE pizza_sales_excel_file
SET new_order_date = STR_TO_DATE(order_date, '%d-%m-%Y');

-- monthly trend query
SELECT  MONTHNAME(new_order_date) as order_month, COUNT(DISTINCT ORDER_ID) as total_orders
FROM pizza_sales_excel_file
group by MONTHNAME(new_order_date);

-- 3. Percentage of sales by pizza category
select * from pizza_sales_excel_file;
SELECT pizza_category, sum(total_price) as total_revenue_by_category, 
cast( (sum(total_price)*100/(SELECT sum(total_price) FROM  pizza_sales_excel_file)) as decimal(10,2) ) as PCT
FROM pizza_sales_excel_file
GROUP BY pizza_category; 

-- 4. percentage of sales by pizza size
SELECT pizza_size, sum(total_price) as total_revenue_by_size, 
cast( (sum(total_price)*100/(SELECT sum(total_price) FROM  pizza_sales_excel_file)) as decimal(10,2) ) as PCT
FROM pizza_sales_excel_file
GROUP BY pizza_size; 

-- 5. Total pizzas sold by pizza category
select * from pizza_sales_excel_file;
SELECT pizza_category, sum(quantity) as total_quantity
FROM pizza_sales_excel_file
GROUP BY pizza_category
order by sum(quantity) DESC;

-- 6 a. top 5 pizaa by total_price / revenue
SELECT pizza_name ,sum(total_price)
FROM pizza_sales_excel_file
group by pizza_name
order by sum(total_price) DESC limit 5;

-- 7.a.  bottom 5 pizaa by total_price / revenue
SELECT pizza_name ,sum(total_price)
FROM pizza_sales_excel_file
group by pizza_name
order by sum(total_price) limit 5;

-- 6 b. top 5 pizaa by total quantity
select * from pizza_sales_excel_file;
SELECT pizza_name ,sum(quantity)
FROM pizza_sales_excel_file
group by pizza_name
order by sum(quantity) DESC limit 5;

-- 7.b.  bottom 5 pizaa by total quantity
SELECT pizza_name ,sum(quantity)
FROM pizza_sales_excel_file
group by pizza_name
order by sum(quantity) limit 5;

-- 6 c. top 5 pizaa by total orders
SELECT pizza_name ,count(distinct order_id) as A
FROM pizza_sales_excel_file
group by pizza_name
order by A DESC limit 5;

-- 7.c.  bottom 5 pizaa by total orders
SELECT pizza_name ,count(distinct order_id) as A
FROM pizza_sales_excel_file
group by pizza_name
order by A limit 5;



