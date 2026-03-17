-- ========================= UNION =========================
-- UNION combines the results of two or more SELECT queries.
-- By default UNION removes duplicate rows (acts like UNION DISTINCT).
-- All SELECT queries must have the same number of columns and compatible data types.

-- Question: Combine first and last names from both tables without duplicates.
select first_name, last_name
from employee_demographics
union
select first_name, last_name
from employee_salary;



-- ========================= UNION ALL =========================
-- UNION ALL combines results but DOES NOT remove duplicates.
-- Faster than UNION because SQL does not check for duplicates.

-- Question: Combine first and last names from both tables including duplicates.
select first_name, last_name
from employee_demographics
union all
select first_name, last_name
from employee_salary;



-- ========================= UNION WITH LABELING =========================
-- Using UNION to categorize employees based on conditions.

-- Question:
-- 1. Label male employees older than 40 as "Old Man".
-- 2. Label female employees older than 40 as "Old Female".
-- 3. Label employees with salary greater than 70000 as "Highly Paid".
-- Combine all results into a single table.

select first_name, last_name, 'Old Man' as Label
from employee_demographics
where age > 40 and gender = 'Male'

union 

select first_name, last_name, 'Old Female' as Label
from employee_demographics
where age > 40 and gender = 'Female'

union

select first_name, last_name, 'Highly paid' as Label
from employee_salary
where salary > 70000

-- Sort final results alphabetically by first and last name
order by first_name, last_name;