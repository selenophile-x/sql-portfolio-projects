-- Percentage of employees have left compared to the total workforce
SELECT
ROUND(100 * SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS attrition_rate_pct
FROM ibm_hr_attrition_raw;


-- The number of employees who left from each department. 
select department,
count(*) as attrition_rate
from ibm_hr_attrition_raw
where attrition = 'yes'
group by department 
order by attrition_rate desc;


-- Comparison of the average monthly income of employees who left vs those who stayed.
select attrition, round(avg(monthlyincome),2) as avg_income from ibm_hr_attrition_raw
group by attrition

  
-- Group employees into age bands (`<30`, `30–40`, `40–50`, `50+`) and their attrition counts
select * from ibm_hr_attrition_raw limit 10 
select 
case when age <30 then 'twenties' 
when age between 30 and 39 then ' thirties' 
when age between 40 and 49 then 'forties' 
else 'fifties' end 
as age_group,
count(*) as attrition
from ibm_hr_attrition_raw
where attrition = 'yes'
group by age_group 
order by age_group 

  
-- Education field having highest attrition.
select educationfield,
count(*) as attrition from ibm_hr_attrition_raw
where attrition = 'yes'
group by educationfield
order by attrition desc

  
-- On average, how many years did employees stay before leaving
SELECT 
ROUND(AVG(YearsAtCompany), 1) AS avg_years_before_exit
FROM ibm_hr_attrition_raw
WHERE Attrition = 'Yes';

