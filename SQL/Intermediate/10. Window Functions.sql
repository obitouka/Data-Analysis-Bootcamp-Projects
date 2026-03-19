-- ========================= WINDOW FUNCTIONS =========================
-- Window functions perform calculations across a group of rows
-- BUT do NOT reduce the number of rows (unlike GROUP BY).


-- ========================= GROUP BY vs WINDOW =========================

-- USING GROUP BY
-- Question: Find average salary per employee (grouped by person).
-- This collapses rows → 1 row per person.

select dem.first_name, dem.last_name, gender, avg(salary) as avg_salary
from employee_demographics as dem
join employee_salary as sal
	on dem.employee_id = sal.employee_id
group by dem.first_name, dem.last_name, gender;


-- USING WINDOW FUNCTION
-- Question: Show each employee along with the average salary of their gender.
-- This keeps all rows and adds the average as an extra column.

select dem.first_name, dem.last_name, gender, 
avg(salary) over(partition by gender) as avg_salary
from employee_demographics as dem
join employee_salary as sal
	on dem.employee_id = sal.employee_id;



-- ========================= RUNNING / ROLLING TOTAL =========================
-- Question: Calculate cumulative (running) salary total within each gender group.

select dem.first_name, dem.last_name, gender, salary,
sum(salary) over(partition by gender order by dem.employee_id) as total
from employee_demographics as dem
join employee_salary as sal
	on dem.employee_id = sal.employee_id;

-- Explanation:
-- PARTITION BY gender → separate groups (Male/Female)
-- ORDER BY employee_id → defines order of accumulation
-- SUM() OVER → running total per group



-- ========================= RANKING FUNCTIONS =========================
-- Used to assign ranks based on salary within each gender.


select dem.first_name, dem.last_name, gender, salary,

-- ROW_NUMBER(): unique sequential number (no ties)
row_number() over(partition by gender order by salary desc) as row_num,

-- RANK(): same rank for ties, skips numbers
rank() over(partition by gender order by salary desc) as rank_num,

-- DENSE_RANK(): same rank for ties, no skipping
dense_rank() over(partition by gender order by salary desc) as dense_rank_num

from employee_demographics as dem
join employee_salary as sal
	on dem.employee_id = sal.employee_id;


-- ========================= SUMMARY =========================
-- GROUP BY → reduces rows (summary)
-- WINDOW → keeps rows + adds calculations

-- PARTITION BY → creates groups (like GROUP BY but without collapsing rows)
-- ORDER BY (inside OVER) → defines calculation order

-- ROW_NUMBER → unique ranking
-- RANK → skips ranks on ties
-- DENSE_RANK → no skipping on ties