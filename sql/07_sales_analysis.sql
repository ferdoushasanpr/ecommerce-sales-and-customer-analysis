---------------------------------------------------------------------------------------How many orders were placed?

SELECT   [OrderStatus],
         COUNT([OrderID]) AS [CountOrders]
FROM     [EcommerceDB].[dbo].[Orders]
GROUP BY [OrderStatus];
