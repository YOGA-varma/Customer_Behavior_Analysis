select * from customer limit 20

select gender, SUM (purchased_amount) as revenue
from customer
group by gender

select customer_id, purchased_amount
from customer
where discount_applied = 'Yes' and purchased_amount >= (select AVG (purchased_amount) from customer)

select item_purchased, (AVG(review_rating::numeric),2) as "Average Product Rating"
from customer
group by item_purchased
order by avg(review_rating) desc
limit 5;

select shipping_type,
AVG(purchased_amount)
from customer
where shipping_type in ('Standard','Express')
group by shipping_type

select subscription_status,
COUNT(customer_id) as total_customer,
ROUND(AVG(purchased_amount),2) as avg_spend,
ROUND(SUM(purchased_amount),2) as total_revenue
from customer 
group by subscription_status
order by total_revenue, avg_spend desc;

select item_purchased,
ROUND(100 * SUM(CASE WHEN discount_applied = 'Yes' THEN 1 ELSE 0 END)/COUNT(*),2) as discount_rate
from customer
group by item_purchased
order by discount_rate desc
limit 5;

with customer_type as(
select customer_id, previous_purchases,
CASE
	WHEN previous_purchases = 1 THEN 'New'
	WHEN previous_purchases BETWEEN 2 AND 10 THEN 'returning'
	ELSE 'Loyal'
	END AS customer_segment
FROM customer
)
select customer_segment, count(*) as "Number of Customers"
from customer_type
group by customer_segment

with item_counts as (
select category,
item_purchased,
COUNT(customer_id) as total_orders,
ROW_NUMBER() OVER (partition by category order by COUNT(customer_id) DESC) as item_rank
from customer
group by category, item_purchased
)
select item_rank, category, item_purchased, total_orders
from item_counts
where item_rank <= 3;

select subscription_status,
count(customer_id) as repeat_buyers
from customer
where previous_purchases > 5
group by subscription_status

select age_group,
SUM(purchased_amount) as total_revenue
from customer
group by age_group
order by total_revenue desc;

