---------------------------------------------------------------------------------------How many orders were placed?

SELECT   [OrderStatus],
         COUNT([OrderID]) AS [CountOrders]
FROM     [EcommerceDB].[dbo].[Orders]
GROUP BY [OrderStatus];

----------------------------------------------------------------------------------------What is the total revenue?

SELECT
    SUM(TotalAmount) AS TotalRevenue
FROM EcommerceDB.dbo.Orders
WHERE OrderStatus = 'Delivered';

----------------------------------------------------------------------------------------What is the monetary value per order status?

SELECT   [OrderStatus],
         COUNT([OrderID]) AS [CountOrders],
         SUM([TotalAmount]) AS [Revenue],
         AVG([TotalAmount]) AS [AverageOrderValue]
FROM     [EcommerceDB].[dbo].[Orders]
GROUP BY [OrderStatus];
