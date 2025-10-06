# Walmart Sales Analysis 

## Project Overview

**Project Title**: Walmart Sales Analysis

**Database Name**: 'Walmart_data'

In order to examine, clean, and analyze retail sales data, data analysts often use SQL skills and methodologies, which this project aims to illustrate.  The project entails creating a database for retail sales, conducting exploratory data analysis (EDA), and using SQL queries to find answers to certain business issues.  For people just starting out in data analysis who wish to establish a strong foundation in SQL, this project is perfect.

## Objectives

 1. **Set up a retail sales database**
 2. **Data Cleaning**
 3. **Exploratory Data Analysis (EDA)**
 4. **Business Analysis**

## Project Structure    

### 1. Database Setup

- **Database Creation**: The project starts by creating a database named project_1.

- **Table Creation**: A table named Walmart_sales is created to store the sales data. The table structure includes columns for invoice_id,Branch
,City,category,unit_price,quantity,date,time,payment_method,rating,profit_margin and Total.

```
SELECT * 
FROM [dbo].[Walmart_sales]

### 2. Data Exploration & Cleaning

- **Record Count**: Determine the total number of records in the dataset.
- **Category Count**: Identify all unique product categories in the dataset.
- **Null Value Check**: Check for any null values in the dataset and delete records with missing data.

```
SELECT COUNT (*)
FROM [dbo].[Walmart_sales]
```
```
SELECT payment_method, COUNT(*)  
FROM walmart_sales
GROUP BY payment_method
```
```
SELECT COUNT(DISTINCT Branch) AS Unique_branch 
FROM walmart_sales
```
```
SELECT MAX(quantity),MIN(quantity)
FROM walmart_sales
```

### 3. Business Problems

**--1. Find different payment method and number of transaction, number of qty sold**

SELECT payment_method, COUNT(*) AS Total_transaction, SUM(quantity) AS Total_quantity  
FROM walmart_sales
GROUP BY payment_method

**--2. Identify the highest-rated category in each branch, displaying the branch, category AVG rating**

WITH CategoryRatings AS (
    SELECT 
        Branch, 
        category, 
        AVG(rating) AS highest_rated_category,
        RANK() OVER(PARTITION BY Branch ORDER BY AVG(rating) DESC ) AS rank
    FROM [dbo].[walmart_sales]
    GROUP BY Branch, category
)
SELECT Branch,
       category,
       highest_rated_category,
       rank
FROM CategoryRatings 
WHERE rank = 1

**--3. Identify the busiest day for each branch based on the number of transactions.**

WITH dailytransactioncount AS(
    SELECT Branch,
           DATENAME(WEEKDAY,date) AS day_name,
           COUNT(*) AS no_transactions,
           RANK() OVER(PARTITION BY branch ORDER BY COUNT(*) DESC ) AS rank1
    FROM [dbo].[walmart_sales]
    GROUP BY Branch, DATENAME(WEEKDAY,date) 
)
SELECT Branch,
       day_name,
       no_transactions,
       rank1
FROM dailytransactioncount
WHERE rank1 = 1

**--4. Calculate the total quantity of items sold per payment method. List payment_method and total_quantity.**

SELECT payment_method,
       SUM(quantity) AS total_quantity_sold
FROM [dbo].[walmart_sales]
GROUP BY payment_method

**--5. Determine the average, minimum and maximum rating of products for each city. List the city, average_rating, min_rating and max_rating.**

SELECT City,
       AVG(rating) AS AVG_rating,
       MIN(rating) AS MIN_rating,
       MAX(rating) AS MAX_rating
FROM [dbo].[walmart_sales]
GROUP BY City

**--6. Calculate the total profit for each category by considering total_profit as (unit_price * quantity * profit_margin).**

SELECT category,
       SUM(unit_price * quantity * profit_margin) AS Total_profit
FROM [dbo].[walmart_sales]
GROUP BY category
ORDER BY Total_profit DESC

**--7. Determine the most common payment method for each Branch. Display Branch and the preferred_payment_method.**

WITH Commonpaymentmethod AS(
    SELECT Branch,
           payment_method,
           COUNT(payment_method) AS Preferred_payment_method,
           RANK() OVER(PARTITION BY Branch ORDER BY COUNT(payment_method) DESC )AS rank1
    FROM [dbo].[walmart_sales]
    GROUP BY Branch, payment_method
)
SELECT * FROM Commonpaymentmethod
WHERE rank1 = 1

