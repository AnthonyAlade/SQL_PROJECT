# SQL_PROJECT

Welcome to my SQL portfolio, in this repository, you will find two SQL projects that highlight my skills in exploratory data analysis and data cleaning.    

## Project Overview  
This repository contains three key SQL projects:  

1. An exploratory data analysis of a COVID-19 dataset, focusing on understanding the pandemic's impact across different regions.  
2. A data cleaning project on a Nashville housing dataset, aimed at preparing the data for analysis by addressing common data quality issues.
3. An exploratory data analysis of a supermarket sales dataset, this project explores a supermarket sales dataset to reveal patterns in sales performance, customer behavior, product popularity, and overall sales performance to provide data-driven insights.
   
## Project 1: Exploratory Data Analysis on COVID-19 Dataset  
### Description  

This project involves analyzing a COVID-19 dataset to derive meaningful insights regarding the pandemic's impact. Key analyses include:  
- Comparing total COVID-19 cases per total deaths by country.  
- Evaluating infection rates in relation to population size.  
- Identifying countries with the highest death counts per population.  
- Analyzing continents with the highest death counts per population.  

### Key Features  
- Comprehensive visualizations comparing case and death statistics.    
- Insights that aim to enhance understanding of the pandemic's global impact.  

### SQL Techniques Used  
- Aggregate functions, joins, and window functions to summarize and analyze datasets.  

### Example Query  

-- Analyzing total cases vs. total deaths 

-- SHOWS LIKELIHOD OF DYING IF YOU CONTRACT COVID IN YOUR COUNTRY

SELECT location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 AS DEATHPERCENTAGE

FROM CovidDeaths$

WHERE location LIKE '%NIGERIA%' AND  continent IS NOT NULL

ORDER BY 1,2

## Project 2: Data Cleaning on Nashville Housing Dataset
### Description

In this project, I focused on a data cleaning task for a Nashville housing dataset. The objective was to prepare the data for further analysis by addressing various data quality issues. Key cleaning actions included:

- Standardizing date formats.
- Populating missing property addresses.
- Breaking down addresses into individual columns (street, city, state, ZIP code).
- Removing duplicates to ensure the dataset is unique.
 -Deleting unused columns to streamline the dataset.

### Key Features

- A cleaned dataset ready for analysis and visualization.
- Improved usability by structuring data into well-defined columns.
- Enhanced data integrity by eliminating duplicates.

### SQL Techniques Used

- String manipulation functions for formatting addresses.
- Date functions to standardize date formats.
- DELETE and INSERT statements for data management.
  
### Example Query 

--STANDARDIZING DATE FORMAT

SELECT *
 
 FROM Nashvillehousing

SELECT SaleDate, CONVERT(date,saledate)
 
 FROM Nashvillehousing

ALTER TABLE Nashvillehousing
 
 ADD Saledateconverted Date

UPDATE Nashvillehousing
 
 SET Saledateconverted = CONVERT(date, saledate)

 ## Project 3: Exploratory Data Analysis on Supermarket sales  Dataset  
### Description  

This project explores a supermarket sales dataset to reveal patterns in sales performance, customer purchasing habits, and product preferences, ultimately aiming to provide actionable insights. Key analysis include

- Total revenue generated by the supermarket  
- Comparing total sales by branch, city and Gender  
- Identifying the most bought product line by the customers  
- Peak sales trend by Date and Time

  ### Key Features
- Insights focused on analyzing sales performance.
- Insights focused on revealing customer preferences across various product lines.

  ### SQL Techniques Used  
- Date functions to standardize date formats.
- Aggregate functions to summarize and analyze datasets.
- Date and time functions to return a specific part of the time and date

  ### Example Query
  SELECT Product_line, ROUND(SUM(Total_Profit),2) AS best_product, SUM(Quantity) AS  units_sold

  FROM [Supermarket sales].[dbo].[Sales_Report]

  GROUP BY Product_line

  ORDER BY SUM(Total_Profit) DESC , SUM(Quantity) 

  

## Technologies Used

-SQL (Microsoft SQL Server)

