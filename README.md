# Walmart Sales Analysis 

## Project Overview

### Introduction

The Walmart Sales Analysis project aims to explore and analyze sales data to uncover patterns, trends, and insights that can drive business decisions. The process involves data cleaning, transformation, and exploration using tools such as Python (Jupyter Notebook) and SQL Server.

### 1. Importing Raw Data into Jupyter Notebook

```
!pip install opendatasets
!pip install sqlalchemy pymysql
!pip install pymysql
import pandas as pd
```

```
import opendatasets as od
od.download("https://www.kaggle.com/datasets/najir0123/walmart-10k-sales-datasets")
from sqlalchemy import create_engine
```
```
df = pd.read_csv("/content/walmart-10k-sales-datasets/Walmart.csv")
```    
### 2. Data exploration & cleaning
```
df.describe()
```
```
df.info()
```
**-- Find NULL & DUPLICATES Value**
```
df.drop_duplicates(inplace=True)
df.duplicated().sum()
```
```
df.isnull().sum()
```
**--Drop the NULL Values if not needed**

### 3. Following data analysis and cleaning, I saved the file to my device and imported it into SQL Server.
```
df.to_csv('walmart_sales.csv', index=False)

from google.colab import files
files.download('walmart_sales.csv')
```

### 4. Creating Database

## Objectives

 1. **Set up a Walmart sales database** 
 2. **Exploratory Data Analysis (EDA)**
 3. **Business Analysis**

**1. Database Setup**

- **Database Creation**: The project starts by creating a database named Walmart_data.

- **Table Creation**: A table named Walmart_sales is created to store the sales data. The table structure includes columns for invoice_id,Branch
,City,category,unit_price,quantity,date,time,payment_method,rating,profit_margin and Total.

- **Importing the data to database**

```
SELECT * 
FROM [dbo].[Walmart_sales]

**3.Business Problems**

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



