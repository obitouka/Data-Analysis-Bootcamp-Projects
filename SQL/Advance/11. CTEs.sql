-- ========================= CTE (COMMON TABLE EXPRESSIONS) =========================
-- CTE is a temporary named result set used inside a query.


-- ========================= BASIC CTE =========================
-- Question: Find average of average salaries grouped by gender.

WITH CTE_Example AS 
(
SELECT gender, MIN(salary) AS min_sal, AVG(salary) AS avg_sal
FROM employee_demographics dem
JOIN employee_salary sal
	ON dem.employee_id = sal.employee_id
GROUP BY gender
)
SELECT AVG(avg_sal)
FROM CTE_Example;

-- Explanation:
-- Inner query → calculates min and avg salary per gender
-- Outer query → calculates average of those avg salaries



-- ========================= CTE WITH COLUMN NAMES =========================
-- Question: Same as above but explicitly naming CTE columns.

WITH CTE_Example (Gender, Min_Sal, Avg_Sal) AS 
(
SELECT gender, MIN(salary), AVG(salary)
FROM employee_demographics dem
JOIN employee_salary sal
	ON dem.employee_id = sal.employee_id
GROUP BY gender
)
SELECT *
FROM CTE_Example;

-- Explanation:
-- Column names are defined after CTE name → (Gender, Min_Sal, Avg_Sal)
-- This is useful when SELECT does not use aliases



-- ========================= MULTIPLE CTEs =========================
-- Question:
-- 1. Get employees born after 1985
-- 2. Get employees with salary >= 50000
-- 3. Combine both results

WITH CTE_Example AS 
(
SELECT employee_id, gender, birth_date
FROM employee_demographics dem
WHERE birth_date > '1985-01-01'
),

CTE_Example2 AS 
(
SELECT employee_id, salary
FROM parks_and_recreation.employee_salary
WHERE salary >= 50000
)

SELECT *
FROM CTE_Example cte1
JOIN CTE_Example2 cte2
	ON cte1.employee_id = cte2.employee_id;

-- Explanation:
-- CTE_Example → filters by birth_date
-- CTE_Example2 → filters by salary
-- Final query → joins both filtered results