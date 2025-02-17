-- This script demonstrates my data cleaning process in MySQL, where I create staging tables, remove duplicates, standardize values, and handle nulls to ensure consistent, analysis-ready data. 
-- I verify every step by checking intermediate results and finally remove unnecessary records to produce a clean, optimized dataset.

-- Step 1: View the original data in the layoffs table
SELECT * FROM layoffs;

-- Step 2: Create a new table "layoffs_staging" that has the same structure as "layoffs"
CREATE TABLE layoffs_staging LIKE layoffs;

-- Step 3: Verify that the new table is created correctly
SELECT * FROM layoffs_staging;

-- Step 4: Copy all data from "layoffs" into "layoffs_staging" for data cleaning
INSERT INTO layoffs_staging 
SELECT * FROM layoffs;

-- Step 5: Verify the copied data
SELECT * FROM layoffs_staging;

-- ====================
-- 1. REMOVE DUPLICATES
-- ====================

-- Identify duplicate records by assigning row numbers within groups of identical data
SELECT *,
ROW_NUMBER() OVER( PARTITION BY 
company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS `row_number`
FROM layoffs_staging;

-- Create a new staging table to store de-duplicated data
CREATE TABLE layoffs_staging2 (
  company TEXT,
  location TEXT,
  industry TEXT,
  total_laid_off INT DEFAULT NULL,
  percentage_laid_off TEXT,
  `date` TEXT,
  stage TEXT,
  country TEXT,
  funds_raised_millions INT DEFAULT NULL,
  `row_number` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Verify the new table structure
SELECT * FROM layoffs_staging2;

-- Insert data into layoffs_staging2 while assigning row numbers to duplicates
INSERT INTO layoffs_staging2
SELECT *,
ROW_NUMBER() OVER( PARTITION BY 
company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS `row_number`
FROM layoffs_staging;

-- Verify the data in layoffs_staging2
SELECT * FROM layoffs_staging2;

-- Remove duplicate records, keeping only the first occurrence (row_number = 1)
DELETE FROM layoffs_staging2 
WHERE `row_number` > 1;

-- Verify that duplicates are removed
SELECT * FROM layoffs_staging2 WHERE `row_number` > 1;

-- ====================
-- 2. STANDARDIZING THE DATA
-- ====================

-- Check and remove extra spaces in the company names
SELECT company, TRIM(company) FROM layoffs_staging2;
UPDATE layoffs_staging2 SET company = TRIM(company);

-- Identify unique values in the industry column for standardization
SELECT DISTINCT industry FROM layoffs_staging2 ORDER BY 1;

-- Identify and standardize variations of "crypto" industry names
SELECT DISTINCT industry FROM layoffs_staging2 WHERE industry LIKE 'crypto%';
UPDATE layoffs_staging2 SET industry = 'crypto' WHERE industry LIKE 'crypto%';

-- Identify inconsistencies in the country column (e.g., "United States.")
SELECT DISTINCT country FROM layoffs_staging2 WHERE country LIKE 'United States%';

-- Trim trailing periods from country names
SELECT DISTINCT country, TRIM(TRAILING '.' FROM country) FROM layoffs_staging2 ORDER BY 1;
UPDATE layoffs_staging2 SET country = TRIM(TRAILING '.' FROM country) WHERE country LIKE 'United States%';

-- Convert date values from text format to proper date format
SELECT DISTINCT `date`, STR_TO_DATE(`date`, '%m/%d/%Y') FROM layoffs_staging2;
UPDATE layoffs_staging2 SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');

-- Change the "date" column to a proper DATE data type
ALTER TABLE layoffs_staging2 MODIFY COLUMN `date` DATE;

-- ====================
-- 3. HANDLING NULL OR BLANK VALUES
-- ====================

-- Replace blank industry values with NULL
UPDATE layoffs_staging2 SET industry = NULL WHERE industry = '';

-- Verify rows where industry is NULL
SELECT * FROM layoffs_staging2 WHERE industry IS NULL OR industry = '';

-- Identify missing industry data by checking companies with valid industry values
SELECT * FROM layoffs_staging2 WHERE company LIKE 'airbnb';
SELECT * FROM layoffs_staging2 t1
JOIN layoffs_staging2 t2 ON t1.company = t2.company
WHERE (t1.industry IS NULL OR t1.industry = '') AND t2.industry IS NOT NULL;

-- Fill missing industry values based on matching company names
UPDATE layoffs_staging2 t1
JOIN layoffs_staging2 t2 ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE t1.industry IS NULL AND t2.industry IS NOT NULL;

-- ====================
-- 4. REMOVING UNNECESSARY DATA
-- ====================

-- Identify records where total_laid_off is NULL
SELECT * FROM layoffs_staging2 WHERE total_laid_off IS NULL;

-- Identify records where both total_laid_off and percentage_laid_off are NULL (useless data)
SELECT * FROM layoffs_staging2 WHERE total_laid_off IS NULL AND percentage_laid_off IS NULL;

-- Delete rows where both total_laid_off and percentage_laid_off are NULL
DELETE FROM layoffs_staging2 WHERE total_laid_off IS NULL AND percentage_laid_off IS NULL;

-- Verify the cleaned data
SELECT * FROM layoffs_staging2;

-- Remove the "row_number" column as it is no longer needed
ALTER TABLE layoffs_staging2 DROP COLUMN `row_number`;

-- Final verification
SELECT * FROM layoffs_staging2;
