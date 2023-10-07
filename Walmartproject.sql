use WalmartData;

create table if not exists sales(
Invoice_ID VARCHAR(40) NOT NULL PRIMARY KEY,
Branch VARCHAR(10) NOT NULL,
City varchar(35) NOT NULL,
Customer_type VARCHAR(30) NOT NULL,
Gender VARCHAR(10) NOT NULL,
Product_line VARCHAR(100) NOT NULL,
Unit_price DECIMAL(10,2) NOT NULL,
Quantity INT NOT NULL,
Tax_5_Percent FLOAT(6,4) NOT NULL,
Total DECIMAL(12,4) NOT NULL,
Date DATETIME NOT NULL,
Time TIME NOT NULL,
Payment_method VARCHAR(15) NOT NULL,
cogs DECIMAL(10,2) NOT NULL,
gross_margin_percent float(11,9),
gross_income DECIMAL(12,4) NOT NULL,
Rating FLOAT(2,1)
) 


SELECT *
FROM SALES;

----------------------------- Creating a column which mentions the time of the day : Morning, Afternoon or Evening ---------

select time,
(case 
	   when 'time' between "00:00:00" and "12:00:00" then "Morning"
	   when 'time' between "12:01:00" and "16:00:00" then "Afternoon"
       else "Evening" 
       end ) as time_of_the_day
 from sales;
 
 
 ALTER TABLE sales 
 ADD column time_of_the_day VARCHAR(25);
 
 update sales
 set Time_Of_the_Day =  (
 case
	   when 'time' between "00:00:00" and "12:00:00" then "Morning"
	   when 'time' between "12:01:00" and "16:00:00" then "Afternoon"
       else "Evening" 
       end ) ;



/*-------------Day_name_information ----------------------------------*/

select 
date ,
dayname(date) as Name_of_the_day
from sales;

alter table sales 
add column day_name varchar(25);



/* Set SQL safe update to 0 since i am in safe mode */ 

SET SQL_SAFE_UPDATES = 0;

/* Updating the day name for all records*/


update sales 
set day_name = DAYNAME(date)
where Customer_type = 'Member';

update sales 
set day_name = DAYNAME(date)
where Customer_type = 'Normal';


/* Updating the month name for all records*/

select 
date,
monthname(date)
from sales;

alter table sales
add column month_name varchar(25);

update sales
set month_name = monthname(date)
where Customer_type = 'Member' or Customer_type= 'Normal';

select *
from sales;



/*Questions 

1. How many unique cities does the data have? 
2. In which city is each branch?
3. How many unique product lines does the data have?
4. What is the most common payment method?
5. What is the most selling product line?
6. What is the total revenue by month?
7. What month had the largest COGS?
8. What product line had the largest revenue?
9. What is the city with the largest revenue?
10. Get each product line & add a column to those product lines that displaying 'Good', 'Bad', Good if it has sales greater than
average sales. 
*/

/* ---1. How many unique cities does the data have?---- */

select count(distinct city)
from sales;

/* -----2. In which city is each branch? */

select distinct city, branch
from sales;

/* ----- 3. How many unique product lines does the data have? */

select 
count(distinct product_line) as Count_Of_Product_lines
from sales;


/*-------4. What is the most common payment method? ------------*/


select Payment_method,count(Payment_method) as Count
from sales
group by Payment_method
order by Payment_method desc;



/*-------5. What is the most selling product lin? ------------*/

select Product_line,count(Quantity) as Count
from sales
group by Product_line
order by Count desc;


/*--------6.What is the total revenue by month? --------------*/

select month_name as Month,
sum(Total) as Revenue
from sales
group by Month
order by Revenue desc;


/* --------- 7. What month had the largest COGS?--------------*/ 


select month_name as Month,
sum(cogs) as Count_Of_Cogs
from sales
group by Month
order by Count_Of_Cogs desc
;

/* 8. What product line had the largest revenue? */

select Product_line,
round(sum(Total),2) as Revenue
from sales
group by Product_line
order by Revenue desc
limit 1;
 
 
/* 9. What is the city with the largest revenue? */

select City,SUM(total) as Revenue
from sales
group by City
Order by Revenue desc
limit 1;


/* 10. Get each product line & add a column to those product lines that displaying 'Good', 'Bad'. 
Good if it has sales greater than average sales. */

select product_line,
(case 
when Total>AVG(Total) then 'Good Sales' else 'Bad Sales' end ) as Display
from sales
group by product_line; 

/* 11. WHich branch sold more products than the average products sold? */

select branch,
sum(quantity) as Products_Sold
from sales 
group by branch
having sum(quantity) > (select avg(quantity) from sales)
order by Products_Sold desc; 


/* 12. What is the most common product line sold by gender? */

select Product_line, Gender,
count(Gender) as Count
from sales
group by  Product_line,Gender
order by Count desc;


/* 13. What is the average rating of each product line ? */

select product_line,
round(avg(Rating),2) as Avg_Rating
from sales
group by product_line
order by Avg_Rating desc
;

/* 14. Find the number of orders placed in each month */ 

select month_name,count(Quantity) No_Of_Orders
from sales 
group by month_name
order by No_Of_Orders desc;



select *
from sales;
