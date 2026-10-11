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

----------------------------------------------------------------------------------------Which warehouses hold the most inventory?

SELECT   [Warehouse],
         SUM([StockQuantity]) AS [TotalQty]
FROM     [EcommerceDB].[dbo].[Inventory]
GROUP BY [Warehouse]
ORDER BY [TotalQty] DESC;


----------------------------------------------------------------------------------------What is the monetary value of inventory?

SELECT 'MonetaryValue' AS [Index],
       SUM([UnitPrice] * [StockQuantity]) AS [Total]
FROM   [EcommerceDB].[dbo].[Inventory] AS i
       INNER JOIN
       [EcommerceDB].[dbo].[Products] AS p
       ON [i].[ProductID] = [p].[ProductID];


