-- SQL EXPLORATORY DATA ANALYSIS PROJECT

-- I don't have any agenda or i don't haveany kind of one thing to find,
-- I just want to explore the data 

-- Just selecting everything to look at the data

SELECT * 
FROM layoff_staging2;

-- lets look at the max laid_off and max percentage_laid_off

SELECT  MAX(total_laid_off),MAX(percentage_laid_off)
FROM layoff_staging2;

-- found out that there are companies with 100% laid off finding which are those compannies

SELECT company , total_laid_off, percentage_laid_off,country
FROM layoff_staging2
WHERE percentage_laid_off = 1
ORDER BY total_laid_off DESC; 

-- Found out that Redbox and Lilium has the most laid_off

-- Now lets look at the companies with most laid_off

SELECT company, SUM(total_laid_off) as total_laid_off
FROM layoff_staging2
GROUP BY company
ORDER BY 2 DESC;

-- Found out that Amazon is at the top with 17690 laid_off

-- Now lets look at the date on first and last laid_off happened

 SELECT MIN(`date`), MAX(`date`)
 FROM layoff_staging2;
 
 -- Found out that on 2023-01-01 there was less and on 2025-03-19 there was max laid_off
 
 -- Lets look at the indusrty which had most laid_off 
 
 SELECT industry , SUM(total_laid_off)
 FROM layoff_staging2
 GROUP BY industry 
 ORDER BY 2 DESC;
 
 -- it seems Other(as shown in the data) and Hardware industry had more laid_off and IT had less

-- Lets look at the country which had most laid_off

 SELECT country , SUM(total_laid_off)
 FROM layoff_staging2
 GROUP BY country
 ORDER BY 2 DESC; 

-- United States has the most number of laid_off (306205)
-- in second its India (26395)
-- Malta has less number of laid_off (29)

-- Lets look at the date and number of employees laid_off and on which year

 SELECT `date` , SUM(total_laid_off)
 FROM layoff_staging2
 GROUP BY `date`
 ORDER BY 2 DESC; 
----------------
 SELECT YEAR(`date`) , SUM(total_laid_off)
 FROM layoff_staging2
 GROUP BY YEAR(`date`)
 ORDER BY 2 DESC; 
 
-- Found out on 2023-01-04 more people lost their jobs (16171)
-- 2023 was the toughest year a total of 264192 lost their jobs

 -- Lets look at the Rolling Total of total layoffs
 
 SELECT SUBSTRING(`date`,1,7) as `MONTH`,
 SUM(total_laid_off)
 FROM layoff_staging2
 GROUP BY `MONTH`
 ORDER BY 1 ASC;

WITH Rolling_total_CTE AS
(
SELECT SUBSTRING(`date`,1,7) as `MONTH`,
 SUM(total_laid_off) AS total_off
 FROM layoff_staging2
 GROUP BY `MONTH`
 ORDER BY 1 ASC
)
SELECT `MONTH`, total_off,
SUM(total_off) OVER(ORDER BY `MONTH`) AS Rolling_Total
FROM Rolling_total_CTE;

-- A TOTAL OF 440030 PEOPLE LOST THEIR JOBS IN THESE YEARS

-- Looking for Company with higher laid_off per year

SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoff_staging2
GROUP BY company,YEAR(`date`)
ORDER BY 3 DESC;

WITH Company_year(Company, Years, Total_laid_off) AS
(
SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoff_staging2
GROUP BY company,YEAR(`date`)
ORDER BY 3 DESC
) ,-- this stores company wise layoffs as a temporary table
  Company_Year_Rank AS(
SELECT * ,
DENSE_RANK() OVER(PARTITION BY Years ORDER BY Total_laid_off DESC) AS ranking
FROM Company_year
 )
SELECT * 
FROM  Company_Year_Rank
WHERE ranking <= 5 ;

-- In 2023 its Amazon
-- in 2024 its Intel
-- in 2025 (3 months only) its Meta