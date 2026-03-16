--  GROUP BY

-- GROUP BY to distinct values: SELECT column FROM databse GROUP BY column
select gender
from employee_demographics
group by gender;

-- Why not use DISTINCT RATHER THAN USING GROUP BY: Normally GROUP BY is used with aggregate functions, like: COUNT(), AVG(), SUM(), MIN(), MAX()
select gender, count(*), count(age), max(age), min(age)
from employee_demographics
group by gender;



-- ORDER BY
-- SELECT * from databse order by column1(priority = 1), column2(priority = 2) desc/asc
select *
from employee_demographics
order by gender, age desc;