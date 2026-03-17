-- ========================= STRING FUNCTIONS =========================


-- ========================= LENGTH() =========================
-- Question: Find the length (number of characters) of a string.

select length('roshan');


-- Question: Display employee first names along with the length of each name.
-- ORDER BY 2 means sort using the second column (name_len).

select first_name, length(first_name) as name_len
from employee_demographics
order by 2;



-- ========================= LOWER() and UPPER() =========================
-- Question: Convert employee names to lowercase and uppercase.

select first_name, 
lower(first_name),
upper(first_name) 
from employee_demographics;



-- ========================= TRIM FUNCTIONS =========================
-- Used to remove spaces from a string.

-- trim() removes spaces from both sides
select trim('     roshan     ');

-- rtrim() removes spaces from the right side
select rtrim('     roshan     ');

-- ltrim() removes spaces from the left side
select ltrim('     roshan     ');



-- ========================= LEFT(), RIGHT(), SUBSTRING() =========================
-- Used to extract parts of a string.

-- LEFT(name, number_of_characters)
-- RIGHT(name, number_of_characters)
-- SUBSTRING(column, starting_position, length)

-- Question:
-- 1. Extract the first 3 letters of the first name.
-- 2. Extract the last 3 letters of the first name.
-- 3. Extract the birth month from birth_date.

select first_name, 
left(first_name, 3),
right(first_name, 3),
birth_date,
substring(birth_date, 6, 2) as birth_month
from employee_demographics;



-- ========================= REPLACE() =========================
-- Used to replace characters or substrings inside a string.

-- Question: Replace letter 'a' with 'z' in employee first names.

select first_name, replace(first_name, 'a', 'z')
from employee_demographics;



-- ========================= LOCATE() =========================
-- Used to find the position of a substring inside a string.
-- Returns the index where the substring first appears.

-- Question: Find the position of 'o' in the word 'rOoshan'.

select locate('o', 'rOoshan');


-- Question: Find where the substring 'an' appears in employee first names.

select first_name, locate('an', first_name)
from employee_demographics;



-- ========================= CONCAT() =========================
-- Used to combine multiple strings together.

-- Question: Combine first_name and last_name into a full name.

select first_name, last_name,
concat(first_name, ' ', last_name) as full_name
from employee_demographics
order by 2;