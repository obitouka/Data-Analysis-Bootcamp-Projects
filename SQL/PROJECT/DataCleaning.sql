-- ========================= PROJECT: DATA CLEANING =========================
/*
STEPS:
1. REMOVE DUPLICATES
2. STANDARDIZE DATA
3. HANDLE NULL / BLANK VALUES
4. REMOVE UNNECESSARY DATA
*/


-- ========================= STEP 0: CREATE STAGING TABLE =========================
-- WHY:
-- We NEVER clean raw/original data directly.
-- If something goes wrong, we lose data permanently.
-- So we create a working copy (staging table).

SELECT *
FROM layoffs;

-- Create table with same structure (no data)
CREATE TABLE layoffs_staging
LIKE layoffs;

-- Copy all data into staging table
INSERT layoffs_staging
SELECT *
FROM layoffs;

-- Verify data copied correctly
SELECT *
FROM layoffs_staging;



-- ========================= STEP 1: IDENTIFY DUPLICATES =========================
-- WHY:
-- We need to find rows that are EXACTLY identical.
-- We use ROW_NUMBER() to assign a number within each duplicate group.

SELECT *,
ROW_NUMBER() OVER(
	PARTITION BY company, location, industry, total_laid_off,
	percentage_laid_off, `date`, stage, country, funds_raised_millions
) AS row_num
FROM layoffs_staging;

-- EXPLANATION:
-- PARTITION BY → groups identical rows
-- row_num = 1 → first occurrence (keep)
-- row_num > 1 → duplicates (remove later)

-- NOTE:
-- This only IDENTIFIES duplicates, does NOT delete them.



-- ========================= STEP 2: ATTEMPT USING CTE (FAILS IN MYSQL) =========================
-- WHY:
-- Logically we want to delete from the result of ROW_NUMBER().
-- But MySQL does NOT allow deleting from a CTE.

WITH duplicate_cte AS
(
SELECT *,
ROW_NUMBER() OVER(
	PARTITION BY company, location, industry, total_laid_off,
	percentage_laid_off, `date`, stage, country, funds_raised_millions
) AS row_num
FROM layoffs_staging
)
DELETE
FROM duplicate_cte
WHERE row_num > 1;

-- RESULT:
-- This fails because CTE is NOT a physical table.



-- ========================= STEP 3: VERIFY SAMPLE =========================
-- WHY:
-- Before deleting anything, we manually check some data.
-- Not all repeated rows are true duplicates.

SELECT *
FROM layoffs_staging
WHERE company = 'Casper';



-- ========================= STEP 4: CREATE CLEAN TABLE =========================
-- WHY:
-- Since we cannot delete from CTE,
-- we create a new table where we STORE row_num physically.

CREATE TABLE layoffs_staging (
	company TEXT,
	location TEXT,
	industry TEXT,
	total_laid_off INT,
	percentage_laid_off TEXT,
	`date` TEXT,
	stage TEXT,
	country TEXT,
	funds_raised_millions INT,
	row_num INT
);



-- ========================= STEP 5: INSERT WITH ROW_NUMBER =========================
-- WHY:
-- ROW_NUMBER() is temporary when used in SELECT.
-- So we store it in a column to use it for deletion.

INSERT INTO layoffs_staging
SELECT *,
ROW_NUMBER() OVER(
	PARTITION BY company, location, industry, total_laid_off,
	percentage_laid_off, `date`, stage, country, funds_raised_millions
) AS row_num
FROM layoffs;

-- RESULT:
-- Each duplicate group now has:
-- row_num = 1 (keep)
-- row_num > 1 (delete)



-- ========================= STEP 6: REMOVE DUPLICATES =========================
-- WHY:
-- We want to KEEP only one row from each duplicate group.
-- So we delete rows where row_num > 1.

DELETE
FROM layoffs_staging
WHERE row_num > 1;

-- IMPORTANT:
-- We DO NOT delete row_num = 1
-- because that is the only valid remaining row.



-- ========================= STEP 7: VERIFY =========================
-- WHY:
-- Ensure duplicates are removed properly.

SELECT *
FROM layoffs_staging
WHERE company = 'Casper';



-- ========================= STEP 8: STANDARDIZE COMPANY =========================
-- WHY:
-- Extra spaces cause mismatches in grouping and analysis.

SELECT *
FROM layoffs_staging
WHERE company != TRIM(company);

UPDATE layoffs_staging
SET company = TRIM(company);



-- ========================= STEP 9: STANDARDIZE INDUSTRY =========================
-- WHY:
-- Same category written differently (e.g., Crypto, CryptoCurrency)
-- should be unified.

SELECT DISTINCT industry
FROM layoffs_staging
ORDER BY 1;

SELECT *
FROM layoffs_staging
WHERE industry LIKE 'Crypto%';

UPDATE layoffs_staging
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';



-- ========================= STEP 10: STANDARDIZE COUNTRY =========================
-- WHY:
-- Some values have trailing "." which creates duplicates logically.

SELECT DISTINCT country
FROM layoffs_staging
ORDER BY 1;

SELECT *
FROM layoffs_staging
WHERE country LIKE 'United States%';

SELECT DISTINCT country, TRIM(TRAILING '.' FROM country)
FROM layoffs_staging;

UPDATE layoffs_staging
SET country = TRIM(TRAILING '.' FROM country)
WHERE country LIKE 'United States%';



-- ========================= STEP 11: FIX DATE FORMAT =========================
-- WHY:
-- Dates are stored as TEXT → cannot perform date operations.

SELECT `date`,
STR_TO_DATE(`date`, '%m/%d/%Y')
FROM layoffs_staging;

UPDATE layoffs_staging
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');

ALTER TABLE layoffs_staging
MODIFY COLUMN `date` DATE;



-- ========================= STEP 12: HANDLE NULL INDUSTRY =========================
-- WHY:
-- Blank values ('') should be treated as NULL for consistency.

UPDATE layoffs_staging
SET industry = NULL
WHERE industry = '';

-- WHY:
-- If same company has known industry elsewhere,
-- we can fill missing values using JOIN.

SELECT t1.industry, t2.industry
FROM layoffs_staging t1
JOIN layoffs_staging t2
	ON t1.company = t2.company
WHERE t1.industry IS NULL
AND t2.industry IS NOT NULL;

UPDATE layoffs_staging t1
JOIN layoffs_staging t2
	ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE t1.industry IS NULL
AND t2.industry IS NOT NULL;



-- ========================= STEP 13: CHECK REMAINING NULLS =========================
-- WHY:
-- Verify if any unresolved missing values remain.

SELECT *
FROM layoffs_staging
WHERE industry IS NULL;



-- ========================= STEP 14: REMOVE USELESS ROWS =========================
-- WHY:
-- Rows with BOTH values NULL provide no useful information for analysis.

SELECT *,
ROW_NUMBER() OVER()
FROM layoffs_staging
WHERE (total_laid_off IS NULL OR total_laid_off = '')
AND (percentage_laid_off IS NULL OR percentage_laid_off = '');

DELETE
FROM layoffs_staging
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;



-- ========================= STEP 15: CLEANUP =========================
-- WHY:
-- row_num was only for duplicate removal → no longer needed.

ALTER TABLE layoffs_staging
DROP COLUMN row_num;








-- ========================= Transfering the cleaned data to a final database =========================
CREATE TABLE layoffs_final
LIKE layoffs_staging;

-- Copy all data into staging table
INSERT layoffs_final
SELECT *
FROM layoffs_staging;

-- Verify data copied correctly
SELECT *
FROM layoffs_final;