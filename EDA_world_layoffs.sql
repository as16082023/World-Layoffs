-- EXPLORATORY DATA ANALYSIS
use world_layoffs;

select *
from layoffs_staging2;

-- Viewing distinct companies in dataset.
SELECT DISTINCT company
FROM layoffs_staging2;
-- 1628 different companies in dataset.

-- Viewing distinct industries in dataset.
SELECT DISTINCT industry
FROM layoffs_staging2;
-- 30 different industries in dataset.

-- Viewing number of companies per industry.
SELECT
  industry,
  COUNT(DISTINCT company) AS num_of_companies
FROM layoffs_staging2
GROUP BY industry
ORDER BY num_of_companies DESC;



select max(total_laid_off)
from layoffs_staging2;

-- Looking at Percentage to see how big these layoffs were
select max(total_laid_off), max(percentage_laid_off)
from layoffs_staging2;


-- Which companies had 1 which is basically 100 percent of they company laid off
select *
from layoffs_staging2
where percentage_laid_off = 1
order by total_laid_off desc;


-- if we order by funds_raised_millions we can see how big some of these companies were
select *
from layoffs_staging2
where percentage_laid_off = 1
order by funds_raised_millions desc;

-- Companies with the most Total Layoffs
select company, sum(total_laid_off) as total_layoffs
from layoffs_staging2
group by company
order by 2 desc;


-- Viewing the min and max dates in our dataset.
select min(`date`), max(`date`)
from layoffs_staging2;
-- The layoffs range from 3/11/2020 to 3/6/2023.

-- Total layoffs by industry
select industry, sum(total_laid_off)
from layoffs_staging2
group by industry
order by 2 desc;

-- Total layoffs by country
select country, sum(total_laid_off) as total_layoffs
from layoffs_staging2
group by country
order by 2 desc;

-- Annual layoffs trend
select year(`date`), sum(total_laid_off) as total_layoffs
from layoffs_staging2
group by year(`date`)
order by 1 desc;

-- Total layoffs by stage
select stage, sum(total_laid_off)
from layoffs_staging2
group by stage
order by 2 desc;

-- Total Layoffs per month
select substring(`date`, 1, 7) as 'month', sum(total_laid_off)
from layoffs_staging2
where substring(`date`, 1, 7) is not null
group by `month`
order by 1 asc;

select * 
from layoffs_staging2;

-- Rolling sum of layoffs using a CTE
with rolling_total as
(
select substring(`date`, 1, 7) as `month`, sum(total_laid_off) as total_layoffs
from layoffs_staging2
where substring(`date`, 1, 7) is not null
group by `month`
order by 1 asc
)
select `month`, total_layoffs
, sum(total_layoffs) over(order by `month`) as rolling_total
from rolling_total;

-- Number of layoffs for each company for each year
SELECT company, YEAR(`date`), SUM(total_laid_off) AS total_layoffs
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
ORDER BY 3 DESC;

-- Viewing the top 10 largest layoffs
select company, year(`date`) as year, sum(total_laid_off) as total_layoffs
from layoffs_staging2
group by company, year(`date`)
order by 3 desc
limit 10;


-- Ranking companies by number of layoffs for each year

with Company_Year ( Company, Years, total_laid_off) as
(
select company, year(`date`), sum(total_laid_off)
from layoffs_staging2
group by company, year(`date`)
)
select *,
dense_rank() over (partition by years order by total_laid_off desc) as Ranking
from Company_Year
where Years is not null
order by Ranking ASC;

with Company_Year ( Company, Industry, Years, total_laid_off) as
(
select company, industry, year(`date`), sum(total_laid_off)
from layoffs_staging2
group by company, industry, year(`date`)
), Company_Year_Rank as
(select *,
dense_rank() over (partition by years order by total_laid_off desc) as Ranking
from Company_Year
where Years is not null
)
select *
from Company_Year_Rank
where Ranking <=5;


