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
