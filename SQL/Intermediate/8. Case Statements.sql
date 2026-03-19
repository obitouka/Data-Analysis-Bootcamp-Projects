-- Case Statements

SELECT first_name,
last_name, 
age,
CASE
	WHEN age <= 30 THEN 'Young'
    WHEN age BETWEEN 31 AND 50 THEN 'Old'
    WHEN age >= 51 THEN 'Applicable for pension'
END AS 'Age_Conditions'
FROM employee_demographics;

/*
PAY INCREASE AND BONUS
	< 50,000 = 5%
	>= 50,000 = 7%
	 FINANCE = 10%
*/

SELECT first_name,
last_name, 
salary,
CASE
	WHEN salary < 50000 THEN salary + (salary * 0.05)
    WHEN salary >= 50000 THEN salary + (salary * 0.07)
END AS 'New_Salary',
CASE
	WHEN dept_id = 6 THEN salary + (salary * 0.10)
    ELSE 0
END AS 'Bonus'
FROM employee_salary;