

# SQL Exploratory Data Analysis (EDA) Project

## **Overview**

This project is an exploratory data analysis (EDA) of layoffs in various companies using SQL. The goal is not to prove a specific hypothesis but rather to explore and analyze the dataset to uncover insights about layoffs across industries, countries, and time periods.

## **Dataset**

The dataset used in this analysis is stored in the layoff_staging2 table, which contains information about layoffs, including:

-- **Company**

-- **Country**

-- **Industry**

-- **Date of layoff**

-- **Total number of employees laid off**

-- **Percentage of workforce laid off**

## **Key Analyses and Findings**

*1. Initial Data Exploration*
```
SELECT *
FROM layoff_staging2;
```
This helps in getting an overall view of the dataset.

*2. Maximum Layoffs and Layoff Percentage*
```
SELECT MAX(total_laid_off), MAX(percentage_laid_off)
FROM layoff_staging2;
```
Identified companies with the highest layoffs.

Some companies had 100% layoffs.

*3. Companies with 100% Layoffs*
```
SELECT company, total_laid_off, percentage_laid_off, country
FROM layoff_staging2
WHERE percentage_laid_off = 1
ORDER BY total_laid_off DESC;
```
Redbox and Lilium had the highest layoffs with complete workforce reductions.

*4. Companies with the Most Layoffs*
```
SELECT company, SUM(total_laid_off) AS total_laid_off
FROM layoff_staging2
GROUP BY company
ORDER BY 2 DESC;
```
Amazon had the highest number of layoffs (17,690).

*5. First and Last Recorded Layoffs*
```
SELECT MIN(`date`), MAX(`date`)
FROM layoff_staging2;
```
The earliest recorded layoff happened on 2023-01-01.

The most recent layoff occurred on 2025-03-19.

*6. Industry with the Most Layoffs*
```
SELECT industry, SUM(total_laid_off)
FROM layoff_staging2
GROUP BY industry
ORDER BY 2 DESC;
```
The "Other" category and Hardware industry had the most layoffs.

IT industry had the least layoffs.

*7. Countries with the Most Layoffs*
```
SELECT country, SUM(total_laid_off)
FROM layoff_staging2
GROUP BY country
ORDER BY 2 DESC;
```
United States had the highest layoffs (306,205).

India followed with 26,395 layoffs.

Malta had the least layoffs (29).

*8. Layoffs by Date*
```
SELECT `date`, SUM(total_laid_off)
FROM layoff_staging2
GROUP BY `date`
ORDER BY 2 DESC;
```
The highest number of layoffs occurred on 2023-01-04 (16,171 layoffs).

*9. Layoffs by Year*
```
SELECT YEAR(`date`), SUM(total_laid_off)
FROM layoff_staging2
GROUP BY YEAR(`date`)
ORDER BY 2 DESC;
```
2023 was the worst year, with 264,192 layoffs.

*10. Rolling Total of Layoffs*
```
WITH Rolling_total_CTE AS (
  SELECT SUBSTRING(`date`,1,7) AS `MONTH`, SUM(total_laid_off) AS total_off
  FROM layoff_staging2
  GROUP BY `MONTH`
  ORDER BY 1 ASC
)
SELECT `MONTH`, total_off,
       SUM(total_off) OVER(ORDER BY `MONTH`) AS Rolling_Total
FROM Rolling_total_CTE;
```
A total of 440,030 people lost their jobs over the recorded period.

*11. Companies with the Most Layoffs Per Year*
```
WITH Company_year(Company, Years, Total_laid_off) AS (
  SELECT company, YEAR(`date`), SUM(total_laid_off)
  FROM layoff_staging2
  GROUP BY company, YEAR(`date`)
  ORDER BY 3 DESC
),
Company_Year_Rank AS (
  SELECT *, DENSE_RANK() OVER(PARTITION BY Years ORDER BY Total_laid_off DESC) AS ranking
  FROM Company_year
)
SELECT *
FROM Company_Year_Rank
WHERE ranking <= 5;
```
2023: Amazon had the most layoffs.

2024: Intel led in layoffs.

2025 (first three months): Meta had the most layoffs.

## **Conclusion**

This SQL exploratory analysis provided insights into:

Companies, industries, and countries most affected by layoffs.

Timeframes of highest layoffs.

Cumulative layoffs over the years.

The findings suggest that tech giants, particularly in the United States, were significantly impacted by layoffs in recent years, with peak layoffs occurring in 2023.

## **Future Improvements**

Deeper analysis using visualization tools like Power BI.

Investigating external factors (economic downturns, company performance).

Incorporating more detailed employee data.

## Author

Jagan P Ramdas

Linkdin : *https://www.linkedin.com/in/jagan-p-ramdas-9b939530a/*




