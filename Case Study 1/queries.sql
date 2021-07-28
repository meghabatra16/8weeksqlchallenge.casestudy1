/* --------------------
   Case Study Questions
   --------------------*/
Query 1

-- 1. What is the total amount each customer spent at the restaurant?
select customer_id, sum(price) 
from sales as s
inner join menu as m
on s.product_id = m.product_id 
group by customer_id
order by customer_id;

| customer_id | sum |
| ----------- | --- |
| A           | 76  |
| B           | 74  |
| C           | 36  |

Query 2

-- 2. How many days has each customer visited the restaurant?
select customer_id, count(distinct order_date) 
from sales
group by customer_id;

| customer_id | count |
| ----------- | ----- |
| A           | 4     |
| B           | 6     |
| C           | 2     |

Query 3

--3. What was the first item from the menu purchased by each customer?
select customer_id, m.product_id, m.product_name, order_date
from menu as m
inner join sales as s
on m.product_id = s.product_id
where order_date = '2021-01-01'
order by customer_id;
 
|customer_id   | product_id |product_name  |   order_date  |
| A	         |     1	    |   "sushi"	 |  "2021-01-01" |
| A	         |     2	    |   "curry"	 |  "2021-01-01" |
| B	         |     2	    |   "curry"	 |  "2021-01-01" |
| C	         |     3	    |   "ramen"	 |  "2021-01-01" |
| C	         |     3	    |    "ramen"   |  "2021-01-01" |

Query 4

-- 4. What is the most purchased item on the menu and how many times was it purchased by all customers?

select count(*), me.product_name 
from menu as me
inner join sales as s
on me.product_id = s.product_id
group by product_name
limit 1;

| product_name | count |
| ------------ | ----- |
| ramen        | 8     |


Query 5
-- 5. Which item was the most popular for each customer?
with ctediners as 
	(select s.customer_id, s.product_id, count(*) as num,
	dense_rank() over(partition by customer_id order by product_id) as rn
	from sales as s
	group by s.customer_id, s.product_id
	)
select d.customer_id,me.product_name, num
from ctediners as d
inner join menu as me
on d.product_id = me.product_id
order by num desc, customer_id desc
limit = 5

| customer_id | product_name |
| ----------- | ------------ |
| A           | ramen        |
| B           | sushi        |
| B           | curry        |
| B           | ramen        |
| C           | ramen        |


-------


##Query 6
-- 6. Which item was purchased first by the customer after they became a member?

With ctediners AS (
select s.*, 
dense_rank() over(partition by customer_id order by order_date) as rn
from sales as s
	)
select d.* 
from ctediners as d
inner join members as me
on d.customer_id = me.customer_id
where order_date >= join_date AND product_id < 3

|customer_id   | product_id |rn      |   order_date  |
| A	         |     2	    |  2     |  "2021-01-07" |
| B	         |     1	    |   4	 |  "2021-01-11" |

Query 7
-- 7. Which item was purchased just before the customer became a member?

With ctediners AS (
select s.*, 
dense_rank() over(partition by customer_id order by order_date desc) as rn
from sales as s
	)
select d.* 
from ctediners as d
inner join members as me
on d.customer_id = me.customer_id
where order_date < join_date and rn = 4

|customer_id   | product_id |  rn    |   order_date  |
| A	         |     2	    |  4     |  "2021-01-01" |
| A	         |     1	    |  4	    |  "2021-01-01" |
| B            |     1      |  4     |  "2021-01-04" |

Query 8
8. What is the total items and amount spent for each member before they became a member?
