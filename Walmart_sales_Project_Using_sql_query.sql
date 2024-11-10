Select * from walmart_sales

select 
Count(*)
from walmart_sales

select
payment_method,
count(*)
from walmart_sales
group by 1

select
count(DISTINCT branch)
from walmart_sales

SELECT
MIN(quantity)
FROM WALMART_SALES


-- Business Problems
--Q.1 Find different payment method and number of transactions, number of qty sold
select
payment_method,
sum(quantity) as no_of_qty_sold,
count(*) as no_of_transa
from walmart_sales
group by payment_method

-- Project Question #2
-- Identify the highest-rated category in each branch, displaying the branch, category
-- AVG RATING
select * from walmart_sales
select
branch,
category,
avg(rating) as avg_rating
from walmart_sales
group by branch,category
order by avg(rating) desc
limit 7

-- Using Window Functions --  ///
with cte as
(
select
	branch,
	category,
	avg(rating) as avg_rating,
	dense_rank() over(partition by branch order by avg(rating)desc) as rk
from walmart_sales
group by branch,category
)

select 
*
from cte 
where rk = 1

-- Q.3 Identify the busiest day for each branch based on the number of transactions
select
branch,
EXTRACT(day from date)  as days,
count(*) as no_of_trans
from walmart_sales
group by branch,EXTRACT(day from date)
order by EXTRACT(day from date)desc
--  Using Windows Functions --//
with cte as
(
select
	branch,
	Extract(day from date) as days_name,
	count(*) as no_of_trans,
	dense_rank() over (partition by branch order by count(*)desc) as rk
from walmart_sales
group by branch,Extract(day from date)
)
select
branch,
days_name,
no_of_trans,
rk
from cte
where rk = 1

-- Q. 4 
-- Calculate the total quantity of items sold per payment method. List payment_method and total_quantity.
select
payment_method,
sum(quantity) as no_of_qunty_sold
from walmart_sales
group by payment_method

-- Q.5
-- Determine the average, minimum, and maximum rating of category for each city. 
-- List the city, average_rating, min_rating, and max_rating.
select * from walmart_sales
select
	city,
	category,
	max(rating) as max_rating,
	avg(rating) as avg_rating,
	min(rating) as min_rating
from walmart_sales
group by city,category

-- Q.6
-- Calculate the total profit for each category by considering total_profit as
-- (unit_price * quantity * profit_margin). 
-- List category and total_profit, ordered from highest to lowest profit.

select 
	category,
	sum(total) as total,
	sum(total * profit_margin) as total_profit
from walmart_sales
group by category
order by sum(total * profit_margin) desc

-- Q.8
-- Categorize sales into 3 group MORNING <12, AFTERNOON 12 to 17, EVENING >17  day time category
-- Find out each of the shift and number of invoices
with cte as 
(
select
	branch,
	Extract(hour from time) as hr, 
	Case
		when Extract(hour from time) <12 Then 'Morning_Trans'
		when Extract(hour from time) Between 12 and 17 Then 'Afternoon_Trans'
		else 'Evening_Trans'
	End as time_shift
	
from walmart_sales
)
select
	branch,
	time_shift,
	count(*) as no_of_invoices
from cte
group by branch,time_shift
order by count(*) desc

-- 
-- #9 Identify 5 branch with highest decrese ratio in 
-- revevenue compare to last year(current year 2023 and last year 2022)

-- rdr == last_rev-cr_rev/ls_rev*100 and last_rev>cr_rec
with last_year_2022_revenue
as
(
select
	branch,
	sum(total) as last_year_rev,
	Extract(year from date) as years
from walmart_sales
where Extract(year from date) = 2022
group by branch,Extract(year from date)
),
current_year_2023_revenue
as
(
select
	branch,
	sum(total) as current_year_rev,
	Extract(year from date) as years
from walmart_sales
where Extract(year from date) = 2023
group by branch,Extract(year from date)
)
select
*,
Round((ls_yr.last_year_rev - cr_yr.current_year_rev)/ls_yr.last_year_rev *100,2) as rev_dec_ratio
from last_year_2022_revenue as ls_yr
inner join current_year_2023_revenue as cr_yr 
on ls_yr.branch = cr_yr.branch
where ls_yr.last_year_rev > cr_yr.current_year_rev
order by rev_dec_ratio desc 
limit 5