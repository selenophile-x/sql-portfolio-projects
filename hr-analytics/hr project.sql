CREATE DATABASE hr_analytics;
USE hr_analytics;
CREATE TABLE ibm_hr_attrition_raw (
  EmployeeNumber INT PRIMARY KEY,
  Age INT,
  Attrition VARCHAR(3),
  BusinessTravel VARCHAR(30),
  DailyRate INT,
  Department VARCHAR(50),
  DistanceFromHome INT,
  Education INT,
  EducationField VARCHAR(50),
  EmployeeCount INT,
  EnvironmentSatisfaction INT,
  Gender VARCHAR(10),
  HourlyRate INT,
  JobInvolvement INT,
  JobLevel INT,
  JobRole VARCHAR(60),
  JobSatisfaction INT,
  MaritalStatus VARCHAR(20),
  MonthlyIncome INT,
  MonthlyRate INT,
  NumCompaniesWorked INT,
  Over18 VARCHAR(5),
  OverTime VARCHAR(5),
  PercentSalaryHike INT,
  PerformanceRating INT,
  RelationshipSatisfaction INT,
  StandardHours INT,
  StockOptionLevel INT,
  TotalWorkingYears INT,
  TrainingTimesLastYear INT,
  WorkLifeBalance INT,
  YearsAtCompany INT,
  YearsInCurrentRole INT,
  YearsSinceLastPromotion INT,
  YearsWithCurrManager INT,
  INDEX ix_attrition (Attrition),
  INDEX ix_department (Department),
  INDEX ix_jobrole (JobRole)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/portfolio/WA_Fn-UseC_-HR-Employee-Attrition.csv'
INTO TABLE ibm_hr_attrition_raw
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'                          
IGNORE 1 LINES
(
  Age,
  Attrition,
  BusinessTravel,
  DailyRate,
  Department,
  DistanceFromHome,
  Education,
  EducationField,
  EmployeeCount,
  EmployeeNumber,
  EnvironmentSatisfaction,
  Gender,
  HourlyRate,
  JobInvolvement,
  JobLevel,
  JobRole,
  JobSatisfaction,
  MaritalStatus,
  MonthlyIncome,
  MonthlyRate,
  NumCompaniesWorked,
  Over18,
  OverTime,
  PercentSalaryHike,
  PerformanceRating,
  RelationshipSatisfaction,
  StandardHours,
  StockOptionLevel,
  TotalWorkingYears,
  TrainingTimesLastYear,
  WorkLifeBalance,
  YearsAtCompany,
  YearsInCurrentRole,
  YearsSinceLastPromotion,
  YearsWithCurrManager
)
SET
  Department       = NULLIF(TRIM(Department), ''),
  EducationField   = NULLIF(TRIM(EducationField), ''),
  JobRole          = NULLIF(TRIM(JobRole), ''),
  Gender           = NULLIF(TRIM(Gender), ''),
  MaritalStatus    = NULLIF(TRIM(MaritalStatus), ''),
  BusinessTravel   = NULLIF(TRIM(BusinessTravel), ''),
  Over18           = NULLIF(TRIM(Over18), ''),
  OverTime         = NULLIF(TRIM(OverTime), ''),
  Attrition        = NULLIF(TRIM(Attrition), '');
SELECT COUNT(*) AS rows_loaded FROM ibm_hr_attrition_raw;


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


-- education field having highest attrition
select educationfield,
count(*) as attrition from ibm_hr_attrition_raw
where attrition = 'yes'
group by educationfield
order by attrition desc


-- how many years did employees stay before leaving
SELECT 
ROUND(AVG(YearsAtCompany), 1) AS avg_years_before_exit
FROM ibm_hr_attrition_raw
WHERE Attrition = 'Yes';

