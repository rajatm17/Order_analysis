--Top 10 highest revenue genrating products

select top 10
	product_id,
	sum(selling_price) as revenue
from
	df_orders
group by
	product_id
order by
	revenue desc

--Find top 5 highest selling products in each region

with cte as(
select
	region,
	product_id,
	sum(selling_price) as sales,
	dense_rank() over(partition by region order by sum(selling_price) desc) as rn
from
	df_orders
group by product_id , region

)
select region,product_id, sales
from cte where rn <=5

--Find month over month growth comparison for 2022 and 2023 sales

with cte as (
	select
	year(order_date) as order_year,
	month(order_date) as order_month,
	sum(selling_price) as sales
	from df_orders
	group by year(order_date), month(order_date)
)

select order_month,
sum(case when order_year=2022 then sales else 0 end) as sales_2022,
sum(case when order_year=2023 then sales else 0 end) as sales_2023
from cte
group by order_month
order by order_month

--For Each Category which month had highest sales

with cte as (
	select
		category,
		format(order_date, 'yyyyMM') as order_year_month,
		sum(selling_price) as sales,
		dense_rank() over(partition by category order by sum(selling_price) desc) as rn
		from df_orders
		group by category, format(order_date, 'yyyyMM')
)
select category, order_year_month, sales
from cte where rn = 1