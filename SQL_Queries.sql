USE business_performance ;

SELECT
COUNT(DISTINCT Order_ID) AS Total_Orders ,
COUNT(DISTINCT Customer_ID) AS Total_Customers ,
SUM(Sales) AS Total_Sales ,
SUM(PROFIT) AS Total_Profit ,
AVG(Sales) AS AverAge_Order_Value 
FROM cleaned_data ;

SHOW COLUMNS FROM cleaned_data ;

SELECT Category ,
SUM(Sales) AS Total_Sales ,
SUM(PROFIT) AS Total_Profit ,
COUNT(DISTINCT Order_ID) AS Total_Orders 
FROM cleaned_data 
GROUP BY Category  
ORDER BY Total_Sales ;

SELECT Region ,
SUM(Sales) AS Total_Sales ,
SUM(PROFIT) AS Total_Profit ,
COUNT(DISTINCT Order_ID) AS Total_Orders 
FROM cleaned_data 
GROUP BY Region 
ORDER BY Total_Sales ;

SELECT Sales_Channel ,
    COUNT(Order_ID) AS Total_Orders ,
    SUM(Sales) AS Total_Sales ,
    SUM(Profit) AS Total_Profit ,
    AVG(Customer_Rating) AS Average_Rating
FROM cleaned_data
GROUP BY Sales_Channel
ORDER BY Total_Sales DESC ;

SELECT Returned ,
    COUNT(Order_ID) AS Total_Orders ,
    SUM(Sales) AS Total_Sales ,
    SUM(Profit) AS Total_Profit
FROM cleaned_data
GROUP BY Returned ;

SELECT 
     Category,
    COUNT(Order_ID) AS Total_Orders,
    SUM(CASE WHEN Returned = 'Yes' THEN 1 ELSE 0 END) AS Returned_Orders,
    ROUND(
        SUM(CASE WHEN Returned = 'Yes' THEN 1 ELSE 0 END)
        * 100.0 / COUNT(Order_ID), 2
    ) AS Return_Rate_Percent
FROM cleaned_data
GROUP BY Category
ORDER BY Return_Rate_Percent DESC;

SELECT
    Return_Reason,
    COUNT(Order_ID) AS Total_Returns
FROM cleaned_data
WHERE Returned = 'Yes'
GROUP BY Return_Reason
ORDER BY Total_Returns DESC;

SELECT
    Discount_Status,
    COUNT(Order_ID) AS Total_Orders,
    SUM(Sales) AS Total_Sales,
    SUM(Net_Profit) AS Total_Net_Profit
FROM cleaned_data
GROUP BY Discount_Status;

SELECT 
    Discount_Status,
    COUNT(Order_ID) AS Total_Orders,
    ROUND(AVG(`Discount_%`), 2) AS Average_Discount,
    ROUND(AVG(Net_Profit), 2) AS Average_Net_Profit
FROM cleaned_data
GROUP BY Discount_Status;

SELECT
    Customer_Segment,
    COUNT(Order_ID) AS Total_Orders,
    SUM(Sales) AS Total_Sales,
    SUM(Net_Profit) AS Total_Net_Profit,
    ROUND(AVG(Customer_Rating), 2) AS Average_Rating
FROM cleaned_data
GROUP BY Customer_Segment
ORDER BY Total_Sales DESC;

SELECT
    DATE_FORMAT(
        CASE
            WHEN CAST(
                SUBSTRING_INDEX(
                    SUBSTRING_INDEX(Order_Date, '-', 2),
                    '-', -1
                ) AS UNSIGNED
            ) > 12
            THEN STR_TO_DATE(Order_Date, '%m-%d-%Y')

            ELSE STR_TO_DATE(Order_Date, '%d-%m-%Y')
        END,
        '%Y-%m'
    ) AS Order_Month,

    ROUND(SUM(Sales), 2) AS Total_Sales,
    ROUND(SUM(Net_Profit), 2) AS Total_Net_Profit,
    COUNT(Order_ID) AS Total_Orders

FROM cleaned_data
GROUP BY Order_Month
ORDER BY Order_Month;

SELECT
    Product_Name,
    Category,
    SUM(Quantity) AS Units_Sold,
    ROUND(SUM(Sales), 2) AS Total_Sales,
    ROUND(SUM(Net_Profit), 2) AS Total_Net_Profit
FROM cleaned_data
GROUP BY Product_Name, Category
ORDER BY Total_Net_Profit DESC
LIMIT 10;

SELECT
    Product_Name,
    Category,
    COUNT(*) AS Total_Records
FROM cleaned_data
GROUP BY Product_Name, Category
ORDER BY Product_Name, Category;

UPDATE cleaned_data
SET Category =
    CASE
        WHEN Product_Name IN (
            'Air Fryer',
            'Bedsheet Set',
            'Coffee Maker',
            'Mixer Grinder',
            'Storage Box'
        ) THEN 'Home & Kitchen'

        WHEN Product_Name IN (
            'Backpack',
            'Cotton Shirt',
            'Denim Jacket',
            'Running Shoes',
            'Sports T-Shirt'
        ) THEN 'Fashion'

        WHEN Product_Name IN (
            'Face Serum',
            'Hair Dryer',
            'Makeup Kit',
            'Perfume',
            'Sunscreen'
        ) THEN 'Beauty'

        WHEN Product_Name IN (
            'Bluetooth Speaker',
            'Laptop',
            'Smartphone',
            'Smartwatch',
            'Wireless Earbuds'
        ) THEN 'Electronics'

        ELSE Category
    END
WHERE Order_ID IS NOT NULL;

SELECT
    Product_Name,
    Category,
    COUNT(*) AS Total_Records
FROM cleaned_data
GROUP BY Product_Name, Category
ORDER BY Product_Name, Category;

SELECT
    CASE
        WHEN Shipping_Cost < 500 THEN 'Low Shipping Cost'
        WHEN Shipping_Cost BETWEEN 500 AND 1000 THEN 'Medium Shipping Cost'
        ELSE 'High Shipping Cost'
    END AS Shipping_Category,

    COUNT(Order_ID) AS Total_Orders,
    ROUND(AVG(Shipping_Cost), 2) AS Average_Shipping_Cost,
    ROUND(AVG(Net_Profit), 2) AS Average_Net_Profit,
    ROUND(SUM(Net_Profit), 2) AS Total_Net_Profit

FROM cleaned_data
GROUP BY Shipping_Category
ORDER BY Average_Shipping_Cost;

SELECT
    COUNT(DISTINCT Order_ID) AS Total_Orders,

    COUNT(DISTINCT Customer_ID) AS Total_Customers,

    ROUND(SUM(Sales), 2) AS Total_Sales,

    ROUND(SUM(Net_Sales), 2) AS Total_Net_Sales,

    ROUND(SUM(Net_Profit), 2) AS Total_Net_Profit,

    ROUND(AVG(Sales), 2) AS Average_Order_Value,

    ROUND(AVG(Customer_Rating), 2) AS Average_Customer_Rating,

    SUM(CASE
        WHEN Returned = 'Yes' THEN 1
        ELSE 0
    END) AS Returned_Orders,

    ROUND(
        SUM(CASE WHEN Returned = 'Yes' THEN 1 ELSE 0 END)
        * 100.0 / COUNT(Order_ID), 2
    ) AS Return_Rate_Percentage,

    SUM(CASE
        WHEN Delivery_Status = 'Delayed' THEN 1
        ELSE 0
    END) AS Delayed_Orders

FROM cleaned_data;

SELECT COUNT(*) AS Total_Records
FROM cleaned_data;

SELECT * FROM cleaned_data
LIMIT 3000;

UPDATE cleaned_data
SET Net_Profit = ROUND(Net_Sales - Total_Cost, 2)
WHERE Order_ID = 'ORD102618';

UPDATE cleaned_data
SET Profit_Status =
    CASE
        WHEN Net_Profit > 0 THEN 'Profit'
        WHEN Net_Profit < 0 THEN 'Loss'
        ELSE 'Break-even'
    END;
    
SELECT
    Profit_Status,
    COUNT(*) AS Total_Orders,
    ROUND(SUM(Net_Profit), 2) AS Total_Net_Profit
FROM cleaned_data
GROUP BY Profit_Status;

SELECT
    COUNT(*) AS Total_Records,

    SUM(Order_ID IS NULL) AS Missing_Order_ID,
    SUM(Order_Date IS NULL) AS Missing_Order_Date,
    SUM(Customer_ID IS NULL) AS Missing_Customer_ID,
    SUM(Product_Name IS NULL) AS Missing_Product_Name,
    SUM(Category IS NULL) AS Missing_Category,
    SUM(Sales IS NULL) AS Missing_Sales,
    SUM(Net_Profit IS NULL) AS Missing_Net_Profit,
    SUM(Profit_Status IS NULL) AS Missing_Profit_Status

FROM cleaned_data;

SELECT *
FROM cleaned_data;