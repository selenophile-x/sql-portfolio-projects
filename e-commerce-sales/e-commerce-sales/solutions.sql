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

-- Top 5 products with highest total quantity sold. Grouped by SKU(stockCode) + Description.

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

-- Top 5 products with highest net revenue.Grouped by SKU(StockCode) + Description.

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


