-- ========================= PROJECT: EXPLORATORY DATA ANALYSIS (EDA) =========================
/*
OBJECTIVE:
Understand patterns, trends, and insights from layoffs data

STEPS:
1. DATA OVERVIEW
2. CHECK EXTREMES (MAX/MIN)
3. TIME RANGE ANALYSIS
4. FULL LAYOFF CASES (100%)
5. COMPANY-WISE ANALYSIS
6. INDUSTRY ANALYSIS
7. COUNTRY ANALYSIS
8. TIME TREND ANALYSIS
9. STAGE ANALYSIS
10. TOP COMPANIES PER YEAR (WINDOW FUNCTIONS)
*/


-- ========================= STEP 1: DATA OVERVIEW =========================
-- View full dataset
SELECT *
FROM layoffs_final;



-- ========================= STEP 2: CHECK EXTREME VALUES =========================
-- Find maximum layoffs and percentage layoffs
SELECT MAX(total_laid_off), MAX(percentage_laid_off)
FROM layoffs_final;



-- ========================= STEP 3: DATE RANGE =========================
-- Understand the time span of the dataset
SELECT MIN(`date`), MAX(`date`)
FROM layoffs_final;
/*
2020-03-11 → 2023-03-06
*/



-- ========================= STEP 4: FULL LAYOFF CASES =========================
-- Companies where 100% employees were laid off
SELECT *
FROM layoffs_final
WHERE percentage_laid_off = 1
ORDER BY total_laid_off DESC;

-- Same but sorted by funding (to see rich companies shutting down)
SELECT *
FROM layoffs_final
WHERE percentage_laid_off = 1
ORDER BY funds_raised_millions DESC;



-- ========================= STEP 5: COMPANY ANALYSIS =========================
-- Total layoffs by company

SELECT company, SUM(total_laid_off)
FROM layoffs_final
GROUP BY company
ORDER BY 2 DESC;

/*
TOP COMPANIES:
Amazon, Google, Meta, Salesforce, Microsoft
*/



-- ========================= STEP 6: INDUSTRY ANALYSIS =========================
-- Which industries were most affected

SELECT industry, SUM(total_laid_off)
FROM layoffs_final
GROUP BY industry
ORDER BY 2 DESC;

/*
TOP INDUSTRIES:
Consumer, Retail, Other, Transportation, Finance
*/



-- ========================= STEP 7: COUNTRY ANALYSIS =========================
-- Which countries had most layoffs

SELECT country, SUM(total_laid_off)
FROM layoffs_final
GROUP BY country
ORDER BY 2 DESC;

/*
TOP COUNTRIES:
USA dominates heavily
*/



-- ========================= STEP 8: TIME TREND ANALYSIS =========================
-- Layoffs per year
SELECT YEAR(`date`), SUM(total_laid_off)
FROM layoffs_final
GROUP BY YEAR(`date`)
ORDER BY 1 DESC;
/*
INSIGHT:
2023	125677
2022	160661
2021	15823
2020	80998

Peak layoffs in 2022
*/



-- ========================= STEP 9: STAGE ANALYSIS =========================
-- Layoffs based on company stage (startup vs big companies)
SELECT stage, SUM(total_laid_off)
FROM layoffs_final
GROUP BY stage
ORDER BY 2 DESC;
/*
INSIGHT:
Post-IPO	204132
Unknown	40716
Acquired	27576
Series C	20017
Series D	19225
Series B	15311
Series E	12697
Series F	9932

Post-IPO companies have highest layoffs → big companies affected most
*/



-- ========================= STEP 10: TOP COMPANIES PER YEAR =========================
-- Using CTE + Window Function
WITH Company_Year (company, years, total_laid_off) AS
(
    -- Aggregate layoffs per company per year
    SELECT company, YEAR(`date`), SUM(total_laid_off)
    FROM layoffs_final
    GROUP BY company, YEAR(`date`)
)
SELECT *, 
       DENSE_RANK() OVER (PARTITION BY years ORDER BY total_laid_off DESC) AS ranking
FROM Company_Year
WHERE years IS NOT NULL
ORDER BY ranking ASC;
/*
Purpose:
Find top companies responsible for layoffs each year
Uber	2020	7525	1
Bytedance	2021	3600	1
Meta	2022	11000	1
Google	2023	12000	1
*/



-- ========================= STEP 11: TOP 5 COMPANIES PER YEAR =========================
-- Filter only top 5 using ranking
WITH Company_Year (company, years, total_laid_off) AS
(
    SELECT company, YEAR(`date`), SUM(total_laid_off)
    FROM layoffs_final
    GROUP BY company, YEAR(`date`)
), 
Company_Year_Rank AS
( 
    SELECT *, 
           DENSE_RANK() OVER (PARTITION BY years ORDER BY total_laid_off DESC) AS ranking
    FROM Company_Year
    WHERE years IS NOT NULL
)
SELECT *
FROM Company_Year_Rank
WHERE ranking <= 5;
/*
Final Insight:
Top companies per year responsible for highest layoffs
Uber	2020	7525	1
Booking.com	2020	4375	2
Groupon	2020	2800	3
Swiggy	2020	2250	4
Airbnb	2020	1900	5
Bytedance	2021	3600	1
Katerra	2021	2434	2
Zillow	2021	2000	3
Instacart	2021	1877	4
WhiteHat Jr	2021	1800	5
Meta	2022	11000	1
Amazon	2022	10150	2
Cisco	2022	4100	3
Peloton	2022	4084	4
Carvana	2022	4000	5
Philips	2022	4000	5
Google	2023	12000	1
Microsoft	2023	10000	2
Ericsson	2023	8500	3
Amazon	2023	8000	4
Salesforce	2023	8000	4
Dell	2023	6650	5
*/