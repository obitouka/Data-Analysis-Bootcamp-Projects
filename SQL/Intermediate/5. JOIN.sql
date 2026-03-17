-- ========================= JOIN =========================
-- Used to combine rows from multiple tables based on a related column


-- ========================= INNER JOIN =========================
-- Question: Get employee id, age and occupation by combining the
-- employee_demographics and employee_salary tables.

select dem.employee_id, age, occupation
from employee_demographics as dem
inner join employee_salary as sal
	on dem.employee_id = sal.employee_id;



-- ========================= OUTER JOIN =========================

-- LEFT JOIN
-- Question: Show all employees from the demographics table and their salary details.
-- If an employee does not have salary information, MySQL fills the salary columns with NULL.

select *
from employee_demographics as dem
left join employee_salary as sal
	on dem.employee_id = sal.employee_id;


-- RIGHT JOIN
-- Question: Show all employees from the salary table and match their demographic details.
-- If an employee exists in the salary table but not in demographics, MySQL fills the demographic columns with NULL.

select *
from employee_demographics as dem
right join employee_salary as sal
	on dem.employee_id = sal.employee_id;



-- ========================= SELF JOIN =========================
-- Used when a table needs to be compared with itself.


-- Question 1: Find employees who are older than other employees.
SELECT emp1.first_name, emp1.age, emp2.first_name
FROM employee_demographics AS emp1
JOIN employee_demographics AS emp2
    ON emp1.age > emp2.age;


-- Question 2: Pair employees with the employee having the next employee_id.
SELECT emp1.employee_id, emp1.first_name, emp2.first_name
FROM employee_demographics emp1
JOIN employee_demographics emp2
    ON emp1.employee_id + 1 = emp2.employee_id;


-- Question 3: Find employees who share the same gender.
-- Prevent matching a row with itself using employee_id != employee_id.

SELECT emp1.first_name, emp2.first_name, emp1.gender
FROM employee_demographics emp1
JOIN employee_demographics emp2
    ON emp1.gender = emp2.gender
    AND emp1.employee_id != emp2.employee_id;



-- ========================= MULTIPLE TABLE JOIN =========================
-- Question: Combine three tables to display employee details,
-- salary information, and department name.

select *
from employee_demographics as dem
inner join employee_salary as sal
	on dem.employee_id = sal.employee_id
inner join parks_departments as pd
	on sal.dept_id = pd.department_id;