# Global Layoffs Analysis

In the rapidly evolving global business landscape, layoffs have become an inevitable reality. Companies across various industries often resort to workforce reductions to maintain profitability, adapt to market changes, or respond to economic downturns. This project aims to analyze a dataset detailing layoffs from companies worldwide to uncover trends and provide insights.

The primary objective of this project is to perform data cleaning and exploratory data analysis (EDA) on a dataset documenting global company layoffs. The analysis seeks to:

- Identify patterns in layoffs across different industries and countries.
- Analyze the distribution of layoffs among companies.
- Understand the broader impact of layoffs on the global workforce.

## Dataset:

The dataset includes records of 2,361 layoffs from various companies worldwide.

## Data Fields :

- company (text): Name of the company that is undergoing layoffs.
- location (text): The city or specific location where the layoffs are taking place.
- industry (text): The sector or industry to which the company belongs.
- total_laid_off (int): The total number of employees being laid off by the company.
- percentage_laid_off (float): The percentage of the company’s workforce that was laid off.
- date (text): The date when the layoffs occurred.
- stage (text): The stage of the company in terms of its funding and development.
- country (text): The country the layoffs are taking place in.
- funds_raised_millions (int): The total amount of funds the company as raised in millions of dollars.

## Data Cleaning:

Data cleaning is a crucial step to ensure that the analysis yields accurate and meaningful insights. The cleaning process involved:

1. Removing Duplicate Records:
- A staging table, layoffs_staging, was created to work on a copy of the original data, preserving the raw dataset.
- Duplicate rows were identified using SQL window functions and subsequently removed.
  
2. Standardizing Data Fields:
- Whitespace in the company column was trimmed.
- Variations in the industry column (e.g., different spellings or cases) were standardized.
- Inconsistent values in the country column were corrected (e.g., removing a trailing period from "United States").
- The date column was converted from text to a proper date format.

3. Handling Missing Values:
- Rows with null values in both total_laid_off and percentage_laid_off were removed, as they were essential for the analysis.
- Blank entries in the industry column were converted to nulls for consistency and filled using data from other records of the same company where possible.

4.Eliminating Unnecessary Columns:
- Columns used only for cleaning purposes, like row_num, were dropped post-cleaning.
- Records missing crucial data were also removed to maintain dataset integrity.

## Exploratory Data Analysis (EDA)
After cleaning the dataset, an exploratory data analysis was conducted to uncover trends and patterns.

- The dataset includes 1,628 distinct companies across 30 different industries.
- Among these industries, Finance had the highest number of companies, while an "Other" category consisted of 91 companies that didn’t fit into the other 29 industries.
- The dataset covers layoffs from March 11, 2020, to March 6, 2023, a period marked by significant global events such as the onset of the COVID-19 pandemic. Analyzing this timeframe 
  provides valuable insights into how these challenges affected various industries and regions.
- The consumer sector witnessed the most significant layoffs, followed closely by the retail industry.
- Large companies like Amazon, Google, and Meta accounted for the most employee layoffs
- Post-IPO companies recorded the highest total number of layoffs.
- The majority of layoffs occurred in 2022 and 2023.
- The United States had the highest number of layoffs, followed by India, the Netherlands, and Sweden.
- Companies with the largest single-day layoffs were Google (12,000), Meta (11,000), Amazon (10,000), Microsoft (10,000), and Ericsson (8,500)



  The analysis of global layoffs from 2020 to 2023 shows that the Consumer and Tech sectors were hit hardest by the pandemic. The Consumer sector struggled with shifts to online shopping and supply chain issues, while the Tech sector, especially post-IPO companies, faced layoffs due to pressures to be profitable. These layoffs were driven mainly by economic, market, and operational factors. Understanding these issues can help businesses and policymakers better support affected industries and protect jobs in the future.
