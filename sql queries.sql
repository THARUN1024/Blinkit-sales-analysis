---------------------------
-- BLINKIT SALES ANALYSIS --
---------------------------

-- 1. VIEW RAW DATA --
SELECT * FROM blinkit_data;

-- 2. DATA CLEANING --
-- Fix inconsistent fat content labels
UPDATE blinkit_data
SET Item_Fat_Content = 
    CASE 
        WHEN Item_Fat_Content IN ('LF', 'low fat') THEN 'Low Fat'
        WHEN Item_Fat_Content = 'reg' THEN 'Regular'
        ELSE Item_Fat_Content
    END;

-- Verify cleaning results
SELECT DISTINCT Item_Fat_Content FROM blinkit_data;

---------------------
-- A. KEY METRICS --
---------------------

-- 1. TOTAL SALES (IN MILLIONS)
SELECT ROUND(SUM(Total_Sales)/1000000.0, 2) AS Total_Sales_Million 
FROM blinkit_data;

-- 2. AVERAGE DAILY SALES
SELECT ROUND(AVG(Total_Sales), 0) AS Avg_Sales 
FROM blinkit_data;

-- 3. TOTAL ITEMS/ORDERS
SELECT COUNT(*) AS No_of_Orders 
FROM blinkit_data;

-- 4. AVERAGE CUSTOMER RATING
SELECT ROUND(AVG(Rating), 1) AS Avg_Rating 
FROM blinkit_data;

--------------------------
-- B. FAT CONTENT SALES --
--------------------------
SELECT Item_Fat_Content, 
       ROUND(SUM(Total_Sales), 2) AS Total_Sales
FROM blinkit_data
GROUP BY Item_Fat_Content;

------------------------
-- C. ITEM TYPE SALES --
------------------------
SELECT Item_Type, 
       ROUND(SUM(Total_Sales), 2) AS Total_Sales
FROM blinkit_data
GROUP BY Item_Type
ORDER BY Total_Sales DESC;

-----------------------------------------
-- D. OUTLET LOCATION FAT SALES BREAKDOWN --
-----------------------------------------
SELECT 
    Outlet_Location_Type,
    COALESCE(SUM(CASE WHEN Item_Fat_Content = 'Low Fat' THEN Total_Sales END), 0) AS Low_Fat,
    COALESCE(SUM(CASE WHEN Item_Fat_Content = 'Regular' THEN Total_Sales END), 0) AS Regular
FROM blinkit_data
GROUP BY Outlet_Location_Type
ORDER BY Outlet_Location_Type;

-------------------------------------
-- E. OUTLET AGE PERFORMANCE ANALYSIS --
-------------------------------------
SELECT Outlet_Establishment_Year, 
       ROUND(SUM(Total_Sales), 2) AS Total_Sales
FROM blinkit_data
GROUP BY Outlet_Establishment_Year
ORDER BY Outlet_Establishment_Year;

-------------------------------------
-- F. OUTLET SIZE CONTRIBUTION --
-------------------------------------
SELECT 
    Outlet_Size,
    ROUND(SUM(Total_Sales), 2) AS Total_Sales,
    ROUND((SUM(Total_Sales) * 100.0 / SUM(SUM(Total_Sales)) OVER()), 2) AS Sales_Percentage
FROM blinkit_data
GROUP BY Outlet_Size
ORDER BY Total_Sales DESC;

-------------------------------
-- G. LOCATION WISE SALES --
-------------------------------
SELECT Outlet_Location_Type, 
       ROUND(SUM(Total_Sales), 2) AS Total_Sales
FROM blinkit_data
GROUP BY Outlet_Location_Type
ORDER BY Total_Sales DESC;

---------------------------------
-- H. OUTLET TYPE PERFORMANCE --
---------------------------------
SELECT 
    Outlet_Type,
    ROUND(SUM(Total_Sales), 2) AS Total_Sales,
    ROUND(AVG(Total_Sales), 0) AS Avg_Sales,
    COUNT(*) AS No_Of_Items,
    ROUND(AVG(Rating), 2) AS Avg_Rating,
    ROUND(AVG(Item_Visibility), 2) AS Visibility
FROM blinkit_data
GROUP BY Outlet_Type
ORDER BY Total_Sales DESC;
