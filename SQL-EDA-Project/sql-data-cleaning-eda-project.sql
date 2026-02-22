SELECT * FROM `layoffs`;

-- Make copy to work with

CREATE TABLE `layoffs_staging`
LIKE `layoffs`;

SELECT * 
FROM `layoffs_staging`;

INSERT `layoffs_staging`
SELECT *
FROM `layoffs`;

-- Remove Duplicates

SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, industry, total_laid_off, percentage_laid_off, `date`) AS row_num
FROM layoffs_staging;

WITH duplicate_cte AS
(
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
FROM layoffs_staging
)
SELECT *
FROM duplicate_cte
WHERE row_num > 1;

CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text, 
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;



INSERT INTO layoffs_staging2
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
FROM layoffs_staging;

SELECT *
FROM layoffs_staging2
WHERE row_num > 1;

DELETE
FROM layoffs_staging2
WHERE row_num > 1;

SELECT *
FROM layoffs_staging2
WHERE row_num > 1;

 -- Standardize the Data
 
 UPDATE layoffs_staging2
 SET company = TRIM(company);
 
 SELECT company
 FROM layoffs_staging2;
 
 SELECT DISTINCT industry
 FROM layoffs_staging2
 ORDER BY industry;
 
 UPDATE layoffs_staging2
 SET industry = 'Crypto'
 WHERE industry LIKE 'Crypto%'; 
 
 SELECT DISTINCT country
 FROM layoffs_staging2
 ORDER BY country;
 
 SELECT * 
 FROM layoffs_staging2
 WHERE country LIKE 'United States%'
 ORDER BY country DESC;
 
 UPDATE layoffs_staging2
 SET country = 'United States'
 WHERE country LIKE 'United States%';
 
 
 UPDATE layoffs_staging2
 SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');
 
 SELECT `date`
 FROM layoffs_staging2;
 
 ALTER TABLE layoffs_staging2
 MODIFY COLUMN `date` DATE;
 
 
 -- NULL Values and blank values
 
 SELECT t1.company, t1.industry, t2.industry
 FROM layoffs_staging2 AS t1
 JOIN layoffs_staging2 AS t2
     ON t1.company = t2.company
 WHERE (t1.industry IS NULL OR t1.industry = '')
 AND t2.industry IS NOT NULL;
 
 UPDATE layoffs_staging2
 SET industry = NULL
 WHERE industry = '';
 
 UPDATE layoffs_staging2 AS t1
 JOIN layoffs_staging2 AS t2
     ON t1.company = t2.company
 SET t1.industry = t2.industry
 WHERE t1.industry IS NULL
 AND t2.industry IS NOT NULL;
 
 SELECT company, industry
 FROM layoffs_staging2
 WHERE industry IS NULL;
 
 -- Bally's remains, but there's no info to be found, so we can't fill it with the appropriate data.
 
 -- Remove any Columns or Rows
 
 SELECT *
 FROM layoffs_staging2
 WHERE total_laid_off IS NULL
 AND percentage_laid_off IS NULL;
 
 DELETE
 FROM layoffs_staging2
 WHERE total_laid_off IS NULL
 AND percentage_laid_off IS NULL;
 
 ALTER TABLE layoffs_staging2
 DROP COLUMN row_num;
 
 SELECT *
 FROM layoffs_staging2;
 
 -- Exploratory Data Analysis

SELECT *
FROM layoffs_staging2;

SELECT MAX(total_laid_off)
FROM layoffs_staging2;

SELECT *
FROM layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY total_laid_off DESC;

SELECT company, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company
ORDER BY SUM(total_laid_off) DESC;

SELECT MIN(`date`), MAX(`date`)
FROM layoffs_staging2;

SELECT industry, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY industry
ORDER BY SUM(total_laid_off) DESC;

SELECT country, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY country
ORDER BY SUM(total_laid_off) DESC;

SELECT YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY YEAR(`date`)
ORDER BY 1 DESC;

SELECT stage, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY stage
ORDER BY 2 DESC;

SELECT SUBSTRING(`date`, 6, 2) AS `MONTH`, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY `MONTH`
ORDER BY `MONTH`;

SELECT SUBSTRING(`date`, 6, 2) AS `MONTH`, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY `MONTH`
ORDER BY 2 DESC;

-- In the following query, 'MONTH' can not be used, because WHERE is executed before SELECT, so 'MONTH' does not exist yet.

SELECT SUBSTRING(`date`, 1, 7) AS `MONTH`, SUM(total_laid_off)
FROM layoffs_staging2
WHERE SUBSTRING(`date`, 1, 7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY `MONTH`;

WITH Rolling_Total AS 
(
SELECT SUBSTRING(`date`, 1, 7) AS `MONTH`, SUM(total_laid_off) AS total_off
FROM layoffs_staging2
WHERE SUBSTRING(`date`, 1, 7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY `MONTH`
)
SELECT `MONTH`, total_off, SUM(total_off) OVER(ORDER BY `MONTH`) AS rolling_total
FROM Rolling_Total;

SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
ORDER BY 3 DESC;

WITH Company_year (company, years, total_laid_off) AS
(
SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
)
SELECT *, DENSE_RANK() OVER (PARTITION BY years ORDER BY total_laid_off DESC) AS Ranking
FROM Company_year
WHERE years IS NOT NULL
ORDER BY Ranking ASC;

WITH Company_year (company, years, total_laid_off) AS
(
SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
)
, Company_year_rank AS
(
SELECT *, DENSE_RANK() OVER (PARTITION BY years ORDER BY total_laid_off DESC) AS Ranking
FROM Company_year
WHERE years IS NOT NULL
)
SELECT *
FROM Company_year_rank
WHERE Ranking <= 5;