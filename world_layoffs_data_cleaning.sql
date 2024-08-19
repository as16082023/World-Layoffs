-- DATA CLEANING 


create database world_layoffs;
use world_layoffs;



select * from layoffs; 

-- First thing we want to do is to create a staging table. This is the one on which we will work in and clean the data.
-- We want a table with raw data if something happens.

create table layoffs_staging
like layoffs; 

select * from layoffs_staging; 

insert layoffs_staging
select *
from layoffs; 


-- During data cleaning, we typically follow these steps:
-- 1. Identify and remove duplicates
-- 2. Standardize data and correct errors
-- 3. Address null values
-- 4. Remove unnecessary columns or rows

-- 1. Remove Duplicates

# First let's check for duplicates

select *,
row_number() over(
partition by company, location, industry, total_laid_off,
percentage_laid_off, `date`, stage,
country, funds_raised_millions) as row_num
from layoffs_staging;

with duplicate_cte as 
(
select *,
row_number() over(
partition by company, location, industry, total_laid_off,
percentage_laid_off, `date`, stage,
country, funds_raised_millions) as row_num
from layoffs_staging 
)
select * 
from duplicate_cte 
where row_num > 1; 

select *
from layoffs_staging
where company = "Casper";


with duplicate_cte as 
(
select *,
row_number() over(
partition by company, location, industry, total_laid_off,
percentage_laid_off, `date`, stage,
country, funds_raised_millions) as row_num
from layoffs_staging 
)
delete
from duplicate_cte 
where row_num > 1; 

-- Creating a new staging table duplicate with a new column for row_num.
create table `layoffs_staging2` (
`company` text,
`location` text,
`industry` text,
`total_laid_off` int default null,
`percentage_laid_off` text,
`date` text,
`stage` text,
`country` text,
`funds_raised_millions` int default null,
row_num int 
) engine = innodb default charset = utf8mb4 collate = utf8mb4_0900_ai_ci;


select * 
from layoffs_staging2; 

-- Insering my original data into the new stagging table.
insert into layoffs_staging2
select *,
row_number() over(
partition by company, location, industry, total_laid_off,
percentage_laid_off, `date`, stage,
country, funds_raised_millions) as row_num
from layoffs_staging ;

-- Selecting the rows of data that are duplicates.
select * 
from layoffs_staging2
where row_num > 1;

set sql_safe_updates = 0;

-- Deleting the duplicate rows (row_num > 1) from the duplicate staging table.
delete 
from layoffs_staging2
where row_num > 1;

select * 
from layoffs_staging2;

---------------------------------------------------------------------------------------------------------------------

-- 2. Standardizing Data

select company, trim(company)
from layoffs_staging2;

-- Updating company's column to remove extra space
update layoffs_staging2
set company = trim(company);

select distinct (industry)
from layoffs_staging2
order by 1;

--  Noticed that Crypto has multiple different variations. We need to standardize that - let's say all to Crypto
select *
from layoffs_staging2
where industry like 'Crypto%';

set sql_safe_updates = 0;

update layoffs_staging2
set industry = 'Crypto'
where industry like 'Crypto%';


select distinct industry
from layoffs_staging2;

-- Apparently we have some "United States" and some "United States." with a period at the end. Let's standardize this.

select distinct country
from layoffs_staging2
order by 1;

select distinct country, trim(trailing '.' from country)
from layoffs_staging2
order by 1;

update layoffs_staging2
set country = trim(trailing '.' from country)
where country like 'United States%';

-- Let's also fix the date columns:
select `date`,
str_to_date(`date`, '%m/%d/%Y')
from layoffs_staging2;

update layoffs_staging2
set `date` = str_to_date(`date`, '%m/%d/%Y');

select * 
from layoffs_staging2;

-- now we can convert the data type properly
alter table layoffs_staging2
modify column `date` DATE;

---------------------------------------------------------------------------------------------------------------------

-- 3. Checking null values

#viewing records which have null values for both numeric columns
select *
from layoffs_staging2
where total_laid_off is null
and percentage_laid_off is null;


-- The industry column has nulls and blank values.
-- Updating the blanks to nulls so they are treated the same

update layoffs_staging2
set industry = null
where industry = '';

select *
from layoffs_staging2
where industry is null
or industry = '';

select * 
from layoffs_staging2
where company = 'Airbnb';

select t1.industry, t2.industry
from layoffs_staging2 t1
join layoffs_staging2 t2
on t1.company = t2.company
--  and t1.location = t2.location
where (t1.industry is null or t1.industry = '')
and t2.industry is not null;

-- populte those nulls if possible
update layoffs_staging2 t1
join layoffs_staging2 t2
on t1.company = t2.company
set t1.industry = t2.industry
where t1.industry is null
and t2.industry is not null;

select *
from layoffs_staging2
where company like 'Bally%';

select *
from layoffs_staging2;


----------------------------------------------------------------------------------------------------------------------

-- 4. Eliminating unnecessary columns

select *
from layoffs_staging2
where total_laid_off is null
and percentage_laid_off is null;

-- Delete Useless data we can't really use
delete
from layoffs_staging2
where total_laid_off is null
and percentage_laid_off is null;

-- The 'row_num' column created earlier to remove duplicate records is now unnecessary and can be deleted.
alter table layoffs_staging2
drop column row_num;

-- Final Cleaned Dataset
select * 
from layoffs_staging2;

-----------------------------------------------------------------------------------------------------------------------


