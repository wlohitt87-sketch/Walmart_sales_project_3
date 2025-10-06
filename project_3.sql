SELECT TOP (1000) [invoice_id]
      ,[Branch]
      ,[City]
      ,[category]
      ,[unit_price]
      ,[quantity]
      ,[date]
      ,[time]
      ,[payment_method]
      ,[rating]
      ,[profit_margin]
      ,[Total]
  FROM [Walmart_data].[dbo].[walmart_sales]

SELECT COUNT(*)
FROM walmart_sales

--
SELECT payment_method, COUNT(*)  
FROM walmart_sales
GROUP BY payment_method

--
SELECT COUNT(DISTINCT Branch) AS Unique_branch 
FROM walmart_sales

--
SELECT MAX(quantity),MIN(quantity)
FROM walmart_sales

-- Business Problems

--1. Find different payment method and number of transaction, number of qty sold?

SELECT payment_method, COUNT(*) AS Total_transaction, SUM(quantity) AS Total_quantity  
FROM walmart_sales
GROUP BY payment_method

--2. Identify the highest-rated category in each branch, displaying the branch, category AVG rating

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

--3. Identify the busiest day for each branch based on the number of transactions.

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

--4. Calculate the total quantity of items sold per payment method. List payment_method and total_quantity.

SELECT payment_method,
       SUM(quantity) AS total_quantity_sold
FROM [dbo].[walmart_sales]
GROUP BY payment_method

--5. Determine the average, minimum and maximum rating of products for each city.
--   List the city, average_rating, min_rating and max_rating.

SELECT City,
       AVG(rating) AS AVG_rating,
       MIN(rating) AS MIN_rating,
       MAX(rating) AS MAX_rating
FROM [dbo].[walmart_sales]
GROUP BY City

--6. Calculate the total profit for each category by considering total_profit as (unit_price * quantity * profit_margin).

SELECT category,
       SUM(unit_price * quantity * profit_margin) AS Total_profit
FROM [dbo].[walmart_sales]
GROUP BY category
ORDER BY Total_profit DESC

--7. Determine the most common payment method for each Branch. Display Branch and the preferred_payment_method.
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

--8. categorize sales into 3 group MORNING, AFTERNOON, EVENING. Find out which of the shift and number of invoices.

SELECT 
   CASE
       WHEN DATEPART(HOUR, time) < 12 THEN 'Morning'
       WHEN DATEPART(HOUR, time) BETWEEN 12 AND 17 THEN 'Afternoon'
       ELSE 'Evening'
   END day_time,
   COUNT(*) As number_of_invoices
FROM [dbo].[walmart_sales]
GROUP BY 
   CASE
       WHEN DATEPART(HOUR, time) < 12 THEN 'Morning'
       WHEN DATEPART(HOUR, time) BETWEEN 12 AND 17 THEN 'Afternoon'
       ELSE 'Evening'
   END 

--9. Identify 5 branch with highest decrease ratio in revenue compare to last year 2023 and last year 2022.

SELECT DATEPART(YEAR, date) AS Year
FROM [dbo].[walmart_sales]

-- 2022 sales 

WITH revenue2022 AS 
(
    SELECT Branch,
           SUM(total) AS revenue
    FROM [dbo].[walmart_sales]
    WHERE DATEPART(YEAR, date) = 2022
    GROUP BY Branch
),
revenue2023 AS
(
    SELECT Branch,
               SUM(total) AS revenue
        FROM [dbo].[walmart_sales]
        WHERE DATEPART(YEAR, date) = 2023
        GROUP BY Branch
)       
SELECT TOP 5 ls.Branch,
       ls.revenue AS last_year_revenue,
       cs.revenue AS Current_year_revenue,
       ROUND((ls.revenue - cs.revenue) * 100 / ls.revenue,2) AS Rev_dec_ratio
FROM revenue2022 ls
JOIN revenue2023 cs
ON ls.Branch = cs.Branch
WHERE ls.revenue > cs.revenue
ORDER BY Rev_dec_ratio DESC

-- END OF THE PROJECT 

