----------------------------------------------------------------------------------------Which products have low inventory?

SELECT   [i].[ProductID],
         [ProductName],
         SUM([StockQuantity]) AS [TotalQty]
FROM     [EcommerceDB].[dbo].[Inventory] AS i
         INNER JOIN
         [EcommerceDB].[dbo].[Products] AS p
         ON [i].[ProductID] = [p].[ProductID]
GROUP BY [i].[ProductID], [ProductName]
ORDER BY [TotalQty] ASC;
