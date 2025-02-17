-- Exploratory Data Analysis (EDA)
-- Analyzing layoff trends, identifying patterns, and detecting anomalies in the dataset.

-- Preview the dataset to understand its structure
SELECT * 
FROM layoffs_staging2;

-- Identifying the largest single layoff event
SELECT MAX(total_laid_off)
FROM layoffs_staging2;

-- Analyzing layoff percentages to understand the impact
SELECT MAX(percentage_laid_off),  MIN(percentage_laid_off)
FROM layoffs_staging2
WHERE  percentage_laid_off IS NOT NULL;

-- Identifying companies where 100% of employees were laid off
SELECT *
FROM layoffs_staging2
WHERE  percentage_laid_off = 1;
-- These are primarily startups that likely shut down during this period.

-- Checking the financial scale of companies that experienced 100% layoffs
SELECT *
FROM layoffs_staging2
WHERE  percentage_laid_off = 1
ORDER BY funds_raised_millions DESC;

-- Companies with the highest number of layoffs in a single event
SELECT company, total_laid_off
FROM layoffs_staging
ORDER BY 2 DESC
LIMIT 5;
-- This represents layoffs occurring on a single day.

-- Companies with the highest total layoffs across all events
SELECT company, SUM(total_laid_off) as most_layoffs
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC
LIMIT 10;

-- Locations with the highest total layoffs
SELECT location, SUM(total_laid_off) most_layoffs
FROM layoffs_staging2
GROUP BY location
ORDER BY 2 DESC
LIMIT 10;

-- Total layoffs by country over the recorded period
SELECT country, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY country
ORDER BY 2 DESC;

-- Yearly layoffs trend
SELECT YEAR(date), SUM(total_laid_off)
FROM layoffs_staging2
WHERE YEAR(date) IS NOT NULL
GROUP BY YEAR(date)
ORDER BY 1 ASC;

-- Industry-wise total layoffs
SELECT industry, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY industry
ORDER BY 2 DESC;

-- Layoffs by company funding stage
SELECT stage, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY stage
ORDER BY 2 DESC;

-- Identifying top companies with the most layoffs per year
WITH Company_Year AS 
(
  SELECT company, YEAR(date) AS years, SUM(total_laid_off) AS total_laid_off
  FROM layoffs_staging2
  GROUP BY company, YEAR(date)
),
Company_Year_Rank AS (
  SELECT company, years, total_laid_off, 
         DENSE_RANK() OVER (PARTITION BY years ORDER BY total_laid_off DESC) AS ranking
  FROM Company_Year
)
SELECT company, years, total_laid_off, ranking
FROM Company_Year_Rank
WHERE ranking <= 3
AND years IS NOT NULL
ORDER BY years ASC, total_laid_off DESC;

-- Monthly layoffs trend analysis
SELECT SUBSTRING(date,1,7) as dates, SUM(total_laid_off) AS total_laid_off
FROM layoffs_staging2
WHERE SUBSTRING(date,1,7) IS NOT NULL
GROUP BY dates
ORDER BY dates ASC;

-- Calculating the rolling total of layoffs over time
WITH DATE_CTE AS 
(
  SELECT SUBSTRING(date,1,7) as dates, SUM(total_laid_off) AS total_laid_off
  FROM layoffs_staging2
  GROUP BY dates
  ORDER BY dates ASC
)
SELECT dates, SUM(total_laid_off) OVER (ORDER BY dates ASC) as rolling_total_layoffs
FROM DATE_CTE
ORDER BY dates ASC;
