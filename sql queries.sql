select * from blinkit_sales

--update inconsistent data
update blinkit_sales
set item_fat_content =
case
when item_fat_content ilike 'l%' then 'Low Fat'
when item_fat_content ilike 'r%' then 'Regular'
else item_fat_content
end

select distinct item_fat_content from blinkit_sales

--KPI's Requirement:

--1. total sales
select round((sum(total_sales)/1000000)::numeric, 2) || ' Millions' as total_sales_formatted
from blinkit_sales;

--2.average sales
select round(avg(total_sales)::numeric,0) as avg_sales
from blinkit_sales

--3.Number of items
select count(*)
from blinkit_sales

--4. average ratings
select round(avg(rating)::numeric,2) as avg_rating
from blinkit_sales

--Granular Requirement
--1. total sales by fat content 
select item_fat_content, 
round(sum(total_sales)::numeric,2) as total_sales, 
round(avg(total_sales)::numeric,0) as avg_sales, 
count(*) as no_of_items, 
round(avg(rating)::numeric,2) as average_rating
from blinkit_sales
group by item_fat_content
order by total_sales desc

--2. total sales by item type
select item_type, 
round(sum(total_sales)::numeric,2) as total_sales, 
round(avg(total_sales)::numeric,0) as avg_sales, 
count(*) as no_of_items, 
round(avg(rating)::numeric,2) as average_rating
from blinkit_sales
group by item_type
order by total_sales desc
limit 5

--3. Fat Content by Outlet for Total Sales
select 
  outlet_location_type,
  coalesce(sum(case when item_fat_content = 'Low Fat' then total_sales end), 0) as low_fat,
  coalesce(sum(case when item_fat_content = 'Regular' then total_sales end), 0) as regular
from blinkit_sales
group by outlet_location_type
order by outlet_location_type;

--4. Total Sales by Outlet Establishment
select outlet_establishment_year, round(sum(total_sales)::numeric,2) as total_sales_year_wise
from blinkit_sales
group by outlet_establishment_year
order by outlet_establishment_year

--Charts Requirement
--1. Percentage of Sales by Outlet Size
select 
  outlet_size, 
  round(sum(total_sales)::numeric, 2) as total_sales,
  round((sum(total_sales) * 100.0 / sum(sum(total_sales)) over ())::numeric, 2) as sales_percentage
from blinkit_sales
group by outlet_size
order by outlet_size

--2.Sales by Outlet Location in percentage
select 
  outlet_location_type, 
  round(sum(total_sales)::numeric, 2) as total_sales,
  round((sum(total_sales) * 100.0 / sum(sum(total_sales)) over ())::numeric, 2) as sales_percentage
from blinkit_sales
group by outlet_location_type
order by outlet_location_type

--3. All Metrics by Outlet Type in percentage
select 
  outlet_type, 
  round(sum(total_sales)::numeric, 2) as total_sales,
  round((sum(total_sales) * 100.0 / sum(sum(total_sales)) over ())::numeric, 2) as sales_percentage
from blinkit_sales
group by outlet_type
order by outlet_type
