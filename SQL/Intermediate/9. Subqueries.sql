-- ========================= SUBQUERIES =========================
-- A subquery is a query inside another query.


-- ========================= SUBQUERY WITH IN =========================
-- Question: Find all employees whose employee_id exists in the salary table
-- where department id = 1.

SELECT *
FROM employee_demographics
WHERE employee_id IN (
	SELECT employee_id
	FROM employee_salary
	WHERE dept_id = 1
);

-- Explanation:
-- Inner query → gets employee_ids from dept 1
-- Outer query → returns matching employees from demographics



-- ========================= SUBQUERY IN SELECT =========================
-- Question: Show each employee's salary along with the overall average salary.

SELECT first_name, salary,
(
	SELECT AVG(salary)
	FROM employee_salary
) AS avg_salary
FROM employee_salary;

-- Explanation:
-- Subquery returns one value (overall average salary)
-- That value is shown for every row (scalar subquery)



-- ========================= SUBQUERY IN FROM (DERIVED TABLE) =========================
-- Question:
-- 1. Calculate avg, max, min, count of age per gender
-- 2. Then find the average of the maximum ages

SELECT AVG(max_age)
FROM (
	SELECT gender, 
           AVG(age) AS avg_age, 
           MAX(age) AS max_age, 
           MIN(age) AS min_age, 
           COUNT(age) AS count_age
	FROM employee_demographics
	GROUP BY gender
) AS Agg_table;

-- Explanation:
-- Inner query → creates a temporary table with aggregates per gender
-- Outer query → calculates average of max_age values