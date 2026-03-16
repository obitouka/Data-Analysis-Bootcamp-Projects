-- LIMIT and ALIASING


-- LIMIT
-- Q) Get top 5 aged people
select *
from employee_demographics
order by age desc
limit 5;
-- LIMIT 5      ;show 5 rows
-- LIMIT 5,2    ;skip 5, show 2


-- ALIASING
select gender, avg(age) as avg_age
from employee_demographics
group by gender
having avg(age) > 30;