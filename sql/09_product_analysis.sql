----------------------------------------------------------------------------------------Which products generate the most revenue?

SELECT   [p].[ProductID],
         [p].[ProductName],
         SUM(oi.Quantity) AS [TotalQty],
         SUM(oi.Quantity * oi.PricePerUnit) AS [Revenue]
FROM     Orders AS o
         INNER JOIN
         Order_Items AS oi
         ON o.OrderID = oi.OrderID
         INNER JOIN
         Products AS p
         ON oi.ProductID = p.ProductID
WHERE    o.OrderStatus = 'Delivered'
GROUP BY [p].[ProductID], [p].[ProductName]
ORDER BY [Revenue] DESC;
