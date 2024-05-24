create database if not exists salesDataWalmart;
create table if not exists Sales(
Invoice_id varchar(30) not null primary key,
branch varchar(5),
city varchar(30)not null,
customer_type varchar(30) not null,
gender varchar(10) not null,
product_line varchar(100) not null,
Unit_price decimal(10,2) not null,
quantity int not null,
VAT float(6,4) not null,
total decimal(12,4) not null,
date datetime not null,
time time not null,
payment_method varchar(15) not null,
cogs decimal(10,2) not null,
gross_margin_pct float(11,2) ,
gross_income decimal(12,4) not null,
rating float(2,1) not null
);


-- ---------------------------------------------------------------------
-- --------------Feature Engineering -----------------------------------
-- time_of_day
select time ,
(case 
when `time` BETWEEN "00:00:00 "AND "12:00:00" THEN "Morning"
when `time` BETWEEN "12:01:00 "AND "16:00:00" THEN "Afternoon"
ELSE "Evening"
END
)AS Time_of_day
from sales;

alter table sales add column Time_of_day varchar(20) ;

SET SQL_SAFE_UPDATES =0;
update sales set time_of_day = (case 
when `time` BETWEEN "00:00:00 "AND "12:00:00" THEN "Morning"
when `time` BETWEEN "12:01:00 "AND "16:00:00" THEN "Afternoon"
ELSE "Evening"
END);
-- ---------------
-- day_name
select date,dayname(date) as day_name from Sales;
alter table Sales add column day_name varchar(10);
Update Sales set day_name = dayname(date);

-- Month_name
select date,Monthname(date) as month_name from Sales;
alter table Sales add column month_name varchar(10);
Update Sales set month_name = monthname(date);

-- ---------------------------------------------------------------------
-- ------------------GENERIC--------------------------------------------
-- how many unique cities does data have
select distinct city from Sales;
select distinct branch from Sales;

-- In which city is each branch
select distinct city,branch from Sales;

-- -----------------------------------------------------------------
-- -------------------------------Product-------------------------

-- how many unique product lines does data have
select count( distinct product_line) as Unique_ProductLine from Sales;

-- What is the most common Payment Method
select Payment_Method,
count(Payment_method) as cnt from sales
group by payment_method
order by cnt desc ;

-- What is the most selling product line
select product_line,
count(product_line) as total from Sales
group by product_line
order by total desc;

-- what is total revenue ny month
select month_name as month,
sum(total) as total_revenue
from sales
group by month
order by total_revenue desc;

-- what month had the largest COGS
select month_name as month,
sum(cogs) as cogs
from sales
group by month
order by cogs desc;

-- what product line had largest revenue
select product_line,
sum(total) as total_revenue from Sales
group by product_line
order by total_revenue desc;

-- what is the city with largest revenue
select city,
		branch,
        sum(total) as total_revenue 
from Sales
group by city,branch
order by total_revenue desc;

-- what product line had largest vat
select product_line,
		avg(vat) as tax 
from Sales
group by product_line
order by tax desc;

-- which branch sold more product then average product sold
select branch,sum(quantity) as qty 
from sales
group by branch
having sum(quantity)>(select avg(quantity) from sales);

-- what is the most common product line by gender
select gender,product_line,count(gender) as cnt
from sales
group by gender,product_line
order by cnt desc;

-- what is the average rating of each product line
select product_line,
		round(avg(rating),2) as avg_rating
from sales
group by product_line
order by avg_rating;
-- --------------------------------------------------------------------
-- ---------------------------------Sales----------------------------------
-- Number of sales made in each time of day per weekday
select time_of_day,count(*) as total_sales
from Sales
where day_name ="Sunday"
group by time_of_day
order by total_sales desc;

-- which of the customer type brings most revenue
select customer_type,
        sum(total) as total_revenue 
from Sales
group by customer_type
order by total_revenue desc;

-- which city has the highest tax 
select city,avg(VAT) as avg_vat
from sales
group by city
order by avg_vat desc;

-- which customer type pays the most VAT
select customer_type,avg(VAT) as avg_vat
from sales
group by customer_type
order by avg_vat desc; 

-- --------------------------------------------------------------
-- ------------------------Customers-----------------------------
-- How many unique customer type does the data have
select count(distinct customer_type) as Unique_CustomerType
from sales;

-- How many unique payment method does the data have
select count(distinct Payment_method) as Payment 
from sales;

-- which customer type buys the most
select customer_type,count(*) as cstm_cnt 
from Sales
group by customer_type;  

-- what is the gender of the most of the Customer
select gender,count(*) as cnt
from sales
group by gender
order by cnt desc;

-- What is the gender distribution per branch
select gender,count(*) as cnt
from sales
where branch="A"
group by gender
order by cnt desc;

-- Which Time of the day the do customer gives most rating
select Time_of_day ,avg(rating) as avg_rating
from sales
where branch ="A"
group by Time_of_day
order by avg_rating desc;

-- Which day of week has the best avg ratings per branch
select day_name ,avg(rating) as avg_rating
from sales
where branch ="A"
group by day_name
order by avg_rating desc;





