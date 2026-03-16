-- WHERE

-- NO CASE SENSITIVE: select * from database where column_name = 'value' (here it fetches all and isn't case sensitive)
select *
from employee_demographics
where first_name = 'tom';

-- CASE SENSITIVE: select * from database where column = 'value' (here it fetches the exact ascii value by applying case sensitivity)
SELECT *
FROM employee_demographics
WHERE binary first_name = 'tom';

-- OR AND: select * from database where column = "value" and not column > value
SELECT *
FROM employee_demographics
WHERE (gender = 'female' and not age < 35) or age < 35;

-- LIKE 
-- %  = matches any number of characters (0, 1, or many)
-- _  = matches exactly one character
-- 'a___%' means:
-- name must start with 'a'
-- followed by at least 3 characters
-- and then anything after that
SELECT *
FROM employee_demographics
WHERE birth_date like '1989%';




-- HAVING(filter groups) vs WHERE(filter rows)

-- Show the genders group where the average employee age is greater than 30
select gender, avg(age)
from employee_demographics
group by gender
having avg(age) > 30;

select occupation, avg(salary)
from employee_salary
where occupation like '%manager%'
group by occupation
having avg(salary) > 75000