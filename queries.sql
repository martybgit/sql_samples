/* ************************************************************************* */
-- Objective: List all products ever sold in alphabetical orders
select
	distinct prod.[name]
from
	samples.orders ord
inner join
	samples.products prod on ord.product_id = prod.product_id
order by 
	prod.[name] asc
/* ************************************************************************* */



/* ************************************************************************* */
-- Objective: List all products ever sold with their total quantity
--               in order of greatest to least quantity
select
	 prod.[name]
	,sum(ord.quantity) as 'total_sold'
from
	samples.orders ord
inner join
	samples.products prod on ord.product_id = prod.product_id
group by
	prod.[name]
order by
	total_sold desc
/* ************************************************************************* */



/* ************************************************************************* */
-- Objective: List all orders, from earliest to current
select
	 tran_id
	,product_id
	,quantity
	,line_price
	,order_date
from
	samples.orders
order by
	tran_id asc, order_date asc
/* ************************************************************************* */



/* ************************************************************************* */

-- Objective: Identify Products that sold today that did not sell yesterday
--               (pick a random date for today)

-- pick a date to serve as 'today'
declare @current_date datetime = '20160124'

select
	distinct today.[name]
from (	-- sold today
		select
			prod.[name]
		from
			samples.orders ord
		inner join
			samples.products prod on ord.product_id = prod.product_id
		where
			ord.order_date = @current_date
) as today
left outer join (
					-- sold yesterday
					select
						prod.[name]
					from
						samples.orders ord
					inner join
						samples.products prod on ord.product_id = prod.product_id
					where
						order_date = @current_date - 1
					) as yesterday					on today.[name] = yesterday.[name]
where
	yesterday.[name] is null
/* ************************************************************************* */



/* ************************************************************************* */
-- Objective: List each Product and its Quantity sold in 2015, by month

select
	 month(ord.order_date) as 'month'
	,year(ord.order_date) as 'year'
	,prod.[name]
	,sum(ord.quantity) as 'total_sold'
from
	samples.orders ord
inner join
	samples.products prod on ord.product_id = prod.product_id
group by
	year(ord.order_date), month(ord.order_date), prod.[name]
order by
	year, month, total_sold desc
/* ************************************************************************* */



/* ************************************************************************* */
-- Objective: List Products that sold at least 10 units in a month in 2015

select
	*
from (
		select
			 month(ord.order_date) as 'month'
			,year(ord.order_date) as 'year'
			,prod.[name]
			,sum(ord.quantity) as 'total_sold'
		from
			samples.orders ord
		inner join
			samples.products prod on ord.product_id = prod.product_id
		group by
			year(ord.order_date), month(ord.order_date), prod.[name]
) as a
where
	a.total_sold >= 10
/* ************************************************************************* */



/* ************************************************************************* */
-- Objective: List the 2nd-best selling Product of all time (based on Quantity)

select
	 a.product_name
	,a.total_sold
	,a.rnk
from (
		select
			 product_name
			,sum(quantity) as 'total_sold'
			,rank() over (order by sum(quantity)) as rnk
		from
			samples.orders
		group by
			product_name
) as a
where
	a.rnk = 2
/* ************************************************************************* */



/* ************************************************************************* */
-- Objective: List quantities sold by month and year on the same line
--               (for an extract/data dump to a flat file to be imported
--                into a data warehouse fact table)

select
	 month
	,year
	,sum(apple_quantity) as apple_quantity
	,sum(banana_quantity) as banana_quantity
	,sum(pear_quantity) as pear_quantity
from (
	select
		 month(order_date) as 'month'
		,year(order_date) as 'year'
		,case product_name when 'apple' then quantity else 0 end as 'apple_quantity'
		,case product_name when 'banana' then quantity else 0 end as 'banana_quantity'
		,case product_name when 'pear' then quantity else 0 end as 'pear_quantity'
	from
		samples.orders
) as a
group by
	month, year
/* ************************************************************************* */
