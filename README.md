# SQL Data Cleaning & Exploratory Data Analysis Projects

This repository contains two SQL projects that demonstrate my ability to clean, transform, and analyze data using MySQL. Both projects focus on a layoffs dataset, where I applied various techniques to prepare the data for analysis and then extracted valuable insights regarding layoff trends, patterns, and anomalies.

## Project 1: Data Cleaning in MySQL
### Objective:
Prepare a raw layoffs dataset for analysis by removing duplicates, standardizing values, handling nulls, and converting data types.

### Key Steps:

Duplicated the original layoffs table to create staging tables.

Removed duplicate records by assigning row numbers and retaining only the first occurrence.

Standardized text fields by trimming extra spaces, unifying variations in industry and country names, and converting date strings to proper date formats.

Handled null or blank values and removed unnecessary records to produce a clean, analysis-ready dataset.

## Project 2: Exploratory Data Analysis (EDA)
### Objective:
Analyze the cleaned layoffs dataset to uncover trends, patterns, and anomalies in the data.

### Key Analysis Performed:

#### Data Overview: Previewed the dataset to understand its structure.

#### Layoff Metrics: Identified the largest single layoff event and analyzed the range of layoff percentages.

#### Company & Location Analysis:
Determined which companies experienced 100% layoffs.

Ranked companies based on the number of layoffs in a single event and overall.

Analyzed layoffs by location and country.

#### Temporal Trends:
Analyzed yearly and monthly layoff trends.

Calculated a rolling total of layoffs over time.

#### Industry & Stage Analysis:
Summarized total layoffs by industry and funding stage.

Used window functions to identify top companies with the most layoffs per year.

### Insights Gained:

Uncovered significant layoff events and identified companies with drastic workforce reductions.

Revealed geographic and industry-specific patterns in layoffs.

Detected temporal trends indicating periods of higher layoff activity.

## Final Thoughts
These SQL projects showcase my proficiency in transforming raw data into an analysis-ready state and extracting meaningful insights through detailed exploratory analysis. The techniques demonstrated here are applicable to various real-world scenarios, providing a foundation for more advanced data analysis and reporting.
