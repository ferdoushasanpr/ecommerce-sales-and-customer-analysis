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


----------------------------------------------------------------------------------------Which products are at high risk, medium risk, or healthy inventory levels based on current stock and average monthly sales over the last six months?

WITH     MonthlySales
AS       (SELECT   oi.ProductID,
                   YEAR(o.OrderDate) AS SalesYear,
                   MONTH(o.OrderDate) AS SalesMonth,
                   SUM(oi.Quantity) AS MonthlyUnitsSold
          FROM     dbo.Orders AS o
                   INNER JOIN
                   dbo.Order_Items AS oi
                   ON o.OrderID = oi.OrderID
          WHERE    o.OrderDate >= DATEADD(MONTH, -6, CAST (GETDATE() AS DATE))
          GROUP BY oi.ProductID, YEAR(o.OrderDate), MONTH(o.OrderDate)),
         SalesVelocity
AS       (SELECT   ProductID,
                   SUM(MonthlyUnitsSold) AS TotalUnitsSold,
                   CAST (SUM(MonthlyUnitsSold) AS DECIMAL (18, 2)) / 6 AS AvgMonthlySales
          FROM     MonthlySales
          GROUP BY ProductID),
         InventoryAnalysis
AS       (SELECT i.ProductID,
                 p.ProductName,
                 i.Warehouse,
                 i.StockQuantity,
                 COALESCE (s.TotalUnitsSold, 0) AS TotalUnitsSold,
                 COALESCE (s.AvgMonthlySales, 0) AS AvgMonthlySales,
                 CASE WHEN COALESCE (s.AvgMonthlySales, 0) > 0 THEN CAST (i.StockQuantity AS DECIMAL (18, 2)) / s.AvgMonthlySales ELSE NULL END AS MonthsOfInventory
          FROM   dbo.Inventory AS i
                 INNER JOIN
                 dbo.Products AS p
                 ON i.ProductID = p.ProductID
                 LEFT OUTER JOIN
                 SalesVelocity AS s
                 ON i.ProductID = s.ProductID)
SELECT   ProductID,
         ProductName,
         Warehouse,
         StockQuantity,
         TotalUnitsSold,
         AvgMonthlySales,
         ROUND(MonthsOfInventory, 2) AS MonthsOfInventory,
         CASE WHEN AvgMonthlySales = 0 THEN 'No Sales' WHEN MonthsOfInventory < 1 THEN 'High-Risk' WHEN MonthsOfInventory < 3 THEN 'Medium-Risk' ELSE 'Healthy' END AS StockStatus
FROM     InventoryAnalysis
ORDER BY ProductID, Warehouse;
