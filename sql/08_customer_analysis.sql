----------------------------------------------------------------------------------------Who are the top 10 customers by total spending?

SELECT   TOP (10) [c].[CustomerID],
                  [c].[FullName],
                  COUNT([o].[OrderID]) AS [TotalOrders],
                  SUM([o].[TotalAmount]) AS [Revenue]
FROM     [EcommerceDB].[dbo].[Orders] AS o
         INNER JOIN
         [EcommerceDB].[dbo].[Customers] AS c
         ON [o].[CustomerID] = [c].[CustomerID]
WHERE    [o].[OrderStatus] = 'Delivered'
GROUP BY [c].[CustomerID], [c].[FullName]
ORDER BY [Revenue] DESC;
