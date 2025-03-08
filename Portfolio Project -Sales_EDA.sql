SELECT TOP (1000) [Invoice _ID]
      ,[Branch]
      ,[City]
      ,[Gender]
      ,[Product_line]
      ,[Unit_price]
      ,[Quantity]
      ,[Tax_5%]
      ,[Total_Profit]
      ,[Date]
      ,[Time]
      ,[Payment]
      ,[production_cost]
      ,[gross income]
  FROM [Supermarket sales].[dbo].[Sales_Report]

  SELECT *
  FROM [Supermarket sales].[dbo].[Sales_Report]
  where Total_Profit > 1000

  --- LETS LOOK AT THE TOTAL PROFIT MADE BY THE SUPERMARKET

  SELECT ROUND(SUM(Total_Profit),2) as total_revenue
  FROM [Supermarket sales].[dbo].[Sales_Report]

 --- TOTAL SALES & REVENUE PER BRANCH & CITY

  SELECT City, Branch, ROUND(SUM(Total_Profit),2) AS branch_revenue, SUM(Quantity) AS  units_sold
  FROM [Supermarket sales].[dbo].[Sales_Report]
  GROUP BY City, Branch
  ORDER BY SUM(Total_Profit) DESC

 --- LETS LOOK AT THE BEST SELLING PRODUCT LINE BY REVENUE and QUANTITY SOLD
  
  SELECT Product_line, ROUND(SUM(Total_Profit),2) AS best_product, SUM(Quantity) AS  units_sold
  FROM [Supermarket sales].[dbo].[Sales_Report]
  GROUP BY Product_line
  ORDER BY SUM(Total_Profit) DESC , SUM(Quantity) 

  --- PEAK SALES TREND BY DATE
  --- WHICH DAY OF THE WEEK HAS THE MOST PROFIT $ SALES MADE
  --- FIRST WE CONERTED THE DATE FROM TEXT TO DATE FORMAT
 
 SELECT *, TRY_CONVERT(DATE,Date,103) as converted_date
 FROM [Supermarket sales].[dbo].[Sales_Report]

 UPDATE [Supermarket sales].[dbo].[Sales_Report]
 SET Date = TRY_CONVERT(DATE,Date,103)

 ALTER TABLE [Supermarket sales].[dbo].[Sales_Report]
 ALTER COLUMN DATE Date
  
 SELECT DATENAME(WEEKDAY, Date) as sales_day, ROUND(SUM(total_profit),2) as total_sales, SUM(Quantity) AS  units_sold
 FROM [Supermarket sales].[dbo].[Sales_Report]
 GROUP BY DATENAME(WEEKDAY, Date) 
 ORDER BY count(*) DESC, SUM(Quantity) DESC

  --- PEAK SALES TREND BY TIME
  --- FIRST CONVERT THE TIME TO TIME FORMAT
  --- I CREATED A NEW COLUMN FOR THE TIME AND THEN I DROP THE OLD COLUMN

  SELECT CAST([Time] as TIME) AS Converted_time
  FROM [Supermarket sales].[dbo].[Sales_Report]

  ALTER TABLE [Supermarket sales].[dbo].[Sales_Report]
  ADD  Converted_time TIME

  UPDATE [Supermarket sales].[dbo].[Sales_Report]
  SET Converted_time = CAST([Time] as TIME)

  ALTER TABLE [Supermarket sales].[dbo].[Sales_Report]
  DROP COLUMN [Time]

  SELECT DATEPART(HOUR,[Converted_time]) as sales_hours, sum(total_profit) as hourly_sales, SUM(Quantity) AS  units_sold
  FROM [Supermarket sales].[dbo].[Sales_Report]
  GROUP BY DATEPART(HOUR,[Converted_time])
  ORDER BY sum(total_profit) DESC, SUM(Quantity) DESC

  -- MOST POPULAR PAYMENT METHOD
 
  SELECT COUNT ( *) as transaction_count , Payment 
  FROM [Supermarket sales].[dbo].[Sales_Report]
  Group by payment
  order by COUNT ( *) desc

 --- TRANSACTION VALUES BY GENDER

  SELECT Gender,SUM(Total_profit) as Total_profit, AVG(Total_profit) as avg_profit, COUNT(*) as total_sales,SUM(Quantity) as Unit_sold
  FROM [Supermarket sales].[dbo].[Sales_Report]
  GROUP BY Gender
  ORDER BY SUM(Total_profit) DESC, AVG(Total_profit) DESC

  --- PRODUCT LINE PREFERENCE BY GENDER
   
   SELECT Gender, product_line , COUNT(*) AS sales_count
   FROM [Supermarket sales].[dbo].[Sales_Report]
   GROUP BY Gender,  product_line
   ORDER BY Gender, COUNT(*) DESC

  --- SALES PER UNIT PRICE CATEGORY

  SELECT COUNT(*) AS Total_sales, SUM(total_profit) as total_profit, 
  CASE WHEN Unit_price < 50 THEN 'low_price' 
       WHEN Unit_price >= 50 THEN 'High_price'
	   ELSE 'Overly expensive'
  END AS Price_category
  FROM [Supermarket sales].[dbo].[Sales_Report]
  GROUP BY   CASE WHEN Unit_price < 50 THEN 'low_price' 
       WHEN Unit_price >= 50 THEN 'High_price'
	   ELSE 'Overly expensive'
  END
  ORDER BY COUNT(*) DESC, SUM(total_profit) DESC;


  