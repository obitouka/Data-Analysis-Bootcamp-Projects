-- SELECT

-- select * from database.table
select * from parks_and_recreation.employee_demographics;

-- selecting multiple columns
-- select column1, column2, column3 from database.table
select employee_id, 
first_name,
age
from parks_and_recreation.employee_demographics;

-- Adding value to age column
-- select column1, column2, column2+10 from database.table
select employee_id, 
age,
age+10
from parks_and_recreation.employee_demographics;

-- DINSTINCT: selecting distinct data of a column
select distinct gender
from parks_and_recreation.employee_demographics;