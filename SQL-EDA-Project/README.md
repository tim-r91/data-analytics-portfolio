# Layoffs Data Cleaning & Exploratory Data Analysis (SQL)

## Project Overview

This project focuses on cleaning and analysing a real-world layoffs dataset using SQL.
The goal was to transform raw, unstructured data into a clean and analysis-ready dataset and perform exploratory data analysis (EDA) to identify trends in layoffs across companies, industries, countries, and time.

This project was completed as part of a guided learning project (Alex The Analyst) with additional independent modifications and exploratory queries to deepen practical SQL and analytical skills.

---

## Business Objective

This project did not start from a predefined business question.
Instead, the objective was to simulate a real-world data analyst workflow by:

* Cleaning messy raw data
* Handling duplicates and missing values
* Standardising inconsistent fields
* Performing exploratory analysis on key variables
* Practising structured analytical querying in SQL

---

## Dataset

* Source: [Layoffs Dataset by Alex The Analyst](https://github.com/AlexTheAnalyst/MySQL-YouTube-Series/blob/main/layoffs.csv)
* Context: Global layoffs dataset
* Structure: Tabular dataset containing company, industry, location, layoffs, funding, and dates
* Key variables: Company, Industry, Country, Total Laid Off, Percentage Laid Off, Date, Stage, Funds Raised

The dataset required significant cleaning before meaningful analysis could be performed.

---

## Data Cleaning (SQL)

All data preparation was performed directly in SQL using a structured staging workflow.

### Key Cleaning Steps:

* Created staging tables to preserve raw data integrity
* Removed duplicate records using `ROW_NUMBER()` window function
* Trimmed and standardised company names
* Standardised inconsistent industry labels
* Unified country naming conventions
* Converted date column from text format to proper DATE type
* Handled NULL and blank values in categorical fields
* Corrected missing industry values using self-joins based on company
* Removed irrelevant rows
* Deleted temporary helper columns after cleaning

---

## Tools & Techniques Used

* SQL (MySQL)
* Data Cleaning in SQL
* Window Functions (ROW_NUMBER, DENSE_RANK)
* Common Table Expressions (CTEs)
* Joins for data imputation
* Aggregations & Grouping
* Exploratory Data Analysis (EDA)

---

## Analysis Features

* Identification of companies with the highest layoffs
* Industry-level layoff analysis
* Country-level layoff distribution
* Yearly and monthly trend analysis
* Rolling total layoffs over time
* Ranking of top companies per year based on layoffs

---

## Key Insights (Exploratory)

* Certain companies experienced significantly higher layoffs than others
* Layoffs varied strongly across industries
* The United States represented a large share of recorded layoffs
* Layoff activity showed clear variation across different years and months

These insights were derived through exploratory querying rather than a predefined hypothesis.

---

## Learning Objectives (Personal)

* Practised real-world data cleaning in SQL
* Learned how to work with messy and inconsistent datasets
* Improved proficiency with window functions and CTEs
* Developed structured analytical thinking using SQL
* Strengthened EDA skills for data analysis projects
* Simulated a realistic data analyst workflow from raw data to insights
