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

----------------------------------------------------------------------------------------What percentage of total revenue comes from each product? 

WITH ProductRevenue AS
(
    SELECT
        p.ProductID,
        p.ProductName,
        p.Category,
        SUM(oi.Quantity * oi.PricePerUnit) AS Revenue
    FROM EcommerceDB.dbo.Order_Items AS oi
    INNER JOIN EcommerceDB.dbo.Orders AS o
        ON oi.OrderID = o.OrderID
    INNER JOIN EcommerceDB.dbo.Products AS p
        ON oi.ProductID = p.ProductID
    WHERE o.OrderStatus = 'Delivered'
    GROUP BY
        p.ProductID,
        p.ProductName,
        p.Category
)
SELECT
    ProductID,
    ProductName,
    Category,
    Revenue,

    Revenue * 100.0 /
        SUM(Revenue) OVER () AS RevenuePercentage

FROM ProductRevenue
ORDER BY Revenue DESC;
