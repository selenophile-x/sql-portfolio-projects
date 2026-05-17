create database ecommerce;
use ecommerce;
CREATE TABLE sales_data (
    InvoiceNo VARCHAR(20),
    StockCode VARCHAR(20),
    Description VARCHAR(200),
    Quantity INT,
    InvoiceDate VARCHAR(25),
    UnitPrice FLOAT,
    CustomerID VARCHAR(20),
    Country VARCHAR(100)
);
load data infile 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/portfolio/data.csv'
INTO TABLE sales_data
CHARACTER SET latin1
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(InvoiceNo, StockCode, @Description, Quantity, @InvoiceDate, @UnitPrice, @CustomerID, Country)
SET
  Description = NULLIF(CONVERT(TRIM(@Description) USING utf8mb4), ''),
  UnitPrice   = NULLIF(@UnitPrice, ''),
  CustomerID  = NULLIF(@CustomerID, ''),
  InvoiceDate = COALESCE(
                  STR_TO_DATE(TRIM(@InvoiceDate), '%m/%d/%Y %H:%i:%s'),
                  STR_TO_DATE(TRIM(@InvoiceDate), '%m/%d/%Y %H:%i')
                );
SET SQL_SAFE_UPDATES = 0;
UPDATE sales_data
SET InvoiceDate = STR_TO_DATE(
    InvoiceDate,
    '%m/%d/%Y %H:%i'
)
WHERE InvoiceDate LIKE '%/%';
ALTER TABLE sales_data MODIFY InvoiceDate DATETIME NULL;


-- Analyze monthly order volume trends
SELECT
YEAR(InvoiceDate) AS yr,
MONTH(InvoiceDate) AS mo,
COUNT(DISTINCT InvoiceNo) AS total_orders
FROM sales_data
WHERE InvoiceNo NOT LIKE 'C%'
GROUP BY YEAR(InvoiceDate), MONTH(InvoiceDate)
ORDER BY yr, mo;


-- Net revenue per month 
select  
month (invoicedate) as mo,
year (invoicedate) as yr,
ROUND(SUM(UnitPrice * Quantity), 2) AS revenue_per_month
from sales_data
group by year(invoicedate), month(invoicedate)
order by yr, mo


-- Top 5 products with highest total quantity sold.
select
stockcode,
description,
sum(quantity) as total_quantity
from sales_data
where invoiceno not like 'c%'
and description is not null
and trim(description) <> ''
group by stockcode, description
order by total_quantity desc, stockcode asc
limit 5;


-- Top 5 products with highest net revenue. Grouped by SKU(StockCode) + Description.
select 
stockcode, 
description, 
round(sum(unitprice * quantity), 2) as revenue from sales_data
where description is not null 
and trim(description) <> ''
group by stockcode, description
order by revenue desc, StockCode asc
limit 5


-- Top 5 countries by net revenue.
select 
country, 
round(sum(unitprice * quantity),2) as revenue_country 
from sales_data
where country is not null
and trim(country) <>''
group by country
order by revenue_country desc, country asc
limit 5


-- Top 5 customers with highest net spend. 
select customerid, country,
round(sum(unitprice * quantity),2) as highest_spend from sales_data
where customerid is not null 
and trim(customerid) <>''
group by customerid, country
order by highest_spend desc, customerid asc
limit 5


