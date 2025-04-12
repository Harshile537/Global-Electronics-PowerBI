select * from sales_details;
select * from customer_details;
select * from exchange_details;
select * from product_details;
select * from stores_details;
describe sales_details;
describe customer_details;
update customer_details set Birthday = str_to_date(Birthday,"%m/%d/%Y");
alter table customer_details modify column Birthday DATE;
set sql_safe_updates = 0;
update sales_details set Order_Date = str_to_date(Order_Date, "%Y-%m-%d");
alter table sales_details modify column Order_Date DATE;
-- stores table
describe  stores_details;
update stores_details set Open_Date = str_to_date(Open_Date,"%Y-%m-%d");
alter table stores_details modify column Open_Date DATE;
-- exchange rate table
update exchange_details set Date = str_to_date(Date,"%Y-%m-%d %H:%i:%s");
alter table exchange_details modify column Date DATE;


-- SQL Queries

-- 1.overall female count
select count(Gender) as Female_count from customer_details where Gender="Female";

-- 2.overall male count
select count(Gender) as Male_count from customer_details where Gender="Male";

-- 3.count of customers in country wise
select sd.Country,count(distinct c.CustomerKey)  as customer_count 
from sales_details c join stores_details sd on c.StoreKey=sd.StoreKey
group by sd.Country order by customer_count desc;

-- 4.overall count of customers
select count(distinct s.CustomerKey)  as customer_count from sales_details s;

-- 5.count of stores in country wise
select Country,count(StoreKey) from stores_details
group by Country order by count(StoreKey) desc;

-- 6.store wise sales
select s.StoreKey,sd.Country,sum(Unit_Price_USD*s.Quantity) as total_sales_amount from product_details pd
join sales_details s on pd.ProductKey=s.ProductKey 
join stores_details sd on s.StoreKey=sd.StoreKey group by s.StoreKey,sd.Country;

-- 7.overall selling amount
select sum(Unit_Price_USD*sd.Quantity) as total_sales_amount from product_details pd
join sales_details sd on pd.ProductKey=sd.ProductKey ;

-- 8.brand count
select Brand ,count(Brand) as brand_count from product_details group by  Brand;

-- 9.cp and sp diff. and profit
select Unit_price_USD,Unit_Cost_USD,round((Unit_price_USD-Unit_Cost_USD),2) as diff,
round(((Unit_price_USD-Unit_Cost_USD)/Unit_Cost_USD)*100,2) as profit_percent
from product_details;

-- 10. brand wise selling amount
select Brand,round(sum(Unit_price_USD*sd.Quantity),2) as sales_amount
from product_details pd join sales_details sd on pd.ProductKey=sd.ProductKey group by Brand;

-- 11.Subcategory wise selling amount
select Subcategory,count(Subcategory) from product_details group by Subcategory;

select Subcategory ,round(sum(Unit_price_USD*sd.Quantity),2) as TOTAL_SALES_AMOUNT
from product_details pd join sales_details sd on pd.ProductKey=sd.ProductKey
 group by Subcategory order by TOTAL_SALES_AMOUNT desc;
 
 -- 11.country overall wise sales
select s.Country,sum(pd.Unit_price_USD*sd.Quantity) as total_sales from product_details pd
join sales_details sd on pd.ProductKey=sd.ProductKey 
join stores_details s on sd.StoreKey=s.StoreKey group by s.Country ;


select s.Country,count(DISTINCT s.StoreKey) as number_of_stores,sum(pd.Unit_price_USD*sd.Quantity) as total_sales from product_details pd
join sales_details sd on pd.ProductKey=sd.ProductKey 
join stores_details s on sd.StoreKey=s.StoreKey group by s.Country ;

-- 12.year wise brand sales
select year(Order_Date),pd.Brand,round(SUM(Unit_price_USD*sd.Quantity),2) as year_sales FROM sales_details sd
join product_details pd on sd.ProductKey=pd.ProductKey group by year(Order_Date),pd.Brand;

-- 13.overall sales with quatity
select Brand,sum(Unit_Price_USD*sd.Quantity) as sp,sum(Unit_Cost_USD*sd.Quantity) as cp,
(SUM(Unit_Price_USD*sd.Quantity) - SUM(Unit_Cost_USD*sd.Quantity)) / SUM(Unit_Cost_USD*sd.Quantity) * 100 as profit 
from product_details pd join sales_details sd on sd.ProductKey=pd.ProductKey
group by Brand;

-- 14.month wise sales with quatity
select month(Order_Date),sum(Unit_Price_USD*sd.Quantity) as sp_month from sales_details
 sd join product_details pd on sd.ProductKey=pd.ProductKey
group by month(Order_Date);


