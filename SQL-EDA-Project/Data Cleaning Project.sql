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