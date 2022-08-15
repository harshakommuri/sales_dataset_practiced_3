create database if not exists sales_ineuron
use sales_ineuron
CREATE TABLE sales_data (
	order_id VARCHAR(15) NOT NULL, 
	order_date VARCHAR(30) NOT NULL, 
	ship_date VARCHAR(30) NOT NULL, 
	ship_mode VARCHAR(14) NOT NULL, 
	customer_name VARCHAR(22) NOT NULL, 
	segment VARCHAR(11) NOT NULL, 
	state VARCHAR(36) NOT NULL, 
	country VARCHAR(32) NOT NULL, 
	market VARCHAR(6) NOT NULL, 
	region VARCHAR(14) NOT NULL, 
	product_id VARCHAR(16) NOT NULL, 
	category VARCHAR(15) NOT NULL, 
	sub_category VARCHAR(11) NOT NULL, 
	product_name VARCHAR(127) NOT NULL, 
	sales DECIMAL(38, 0) NOT NULL, 
	quantity DECIMAL(38, 0) NOT NULL, 
	discount DECIMAL(38, 3) NOT NULL, 
	profit DECIMAL(38, 5) NOT NULL, 
	shipping_cost DECIMAL(38, 2) NOT NULL, 
	order_priority VARCHAR(8) NOT NULL, 
	`year` DECIMAL(38, 0) NOT NULL
);
select * from sales_data


# we use the below query to make mysql avoid any errors in dataset, it will help to insert bulk data without any problems
set session sql_mode = ' '

#Inserting bult data automatically without doing manually. spreedsheet always should be .CSV formate for this method.
load data infile 'D:\sales_data_final.csv'
into table sales_data
fields terminated by ','
enclosed by '"'
lines terminated by '\n'
ignore 1 rows

# the below query will help us to convert the varchar to date datatype
select str_to_date(order_date, '%m/%d/%Y') from sales_data

# the beow Query is to make changes to existing table
alter table sales_data
# adding new column after perticular column.
add column order_date_new date after order_date

# while running below 2 update and set queries I got error saying I am using safe mode, to avoid that we are using below query.
SET SQL_SAFE_UPDATES = 0;

# updating the table
update sales_data
#inserting the data into new empty column while modifing simaltanusly
set order_date_new = str_to_date(order_date, '%m/%d/%Y') 

alter table sales_data
add column ship_date_new date after ship_date

update sales_data
set ship_date_new = str_to_date(ship_date, '%m/%d/%Y') 

# To find out current time and date in our system
select now()
select curdate()
select curtime()

# The below query will help us to find all the data before 1 week ago, here we substracted now() with 1 week.
select * from sales_data where ship_date_new < date_sub(now() , interval 1 week)

#here we substracted now() with 1 week.
select date_sub(now(), interval 1 week)

select year(now())
select day(now())
select dayname(now())
select dayname('2022-08-05 16:56:03')
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

# converting year column datatype from decimal to datetime (wrong query)
alter table sales_data
modify column `year` datetime

alter table sales_data
add column year_new int
alter table sales_data
add column month_new int
alter table sales_data
add column day_new int
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

# Here we created 3 new columns and filled those columns from order_date_new data
update sales_data
set year_new = year(order_date_new)
update sales_data
set month_new = month(order_date_new)
update sales_data
set day_new = day(order_date_new)
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

# finding average sales from year 2011
select year_new, avg(sales) from sales_data where year_new = '2011'
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

# it will give average sales by year wise
SELECT 
    year_new, AVG(sales)
FROM
    sales_data
GROUP BY year_new

select year_new, sum(sales) from sales_data group by year_new
select year_new, min(sales) from sales_data group by year_new
select year_new, max(sales) from sales_data group by year_new

# Adding data of two columns.
select discount + shipping_cost as cost_of_company from sales_data
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

# findind the cost of the comapany
select ((discount*sales) + shipping_cost) as CTC , discount + shipping_cost as cost_of_company from sales_data
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

# usage IF condetion 
select order_id, discount, if (discount>0, 'yes', 'no') as discount_flag from sales_data

select order_id, discount, if (discount>0, 'yes', 'no') as discount_flag, count('yes') from discount_flag as yes_count ,  count('no') from discount_flag as no_count from sales_data
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

# finding number of discount_flags with yes and no's
alter table sales_data
add column discount_flag varchar(20)

update sales_data
set discount_flag = if (discount>0, 'yes', 'no');

select discount_flag, count(*) from sales_data group by discount_flag

select * from sales_data



