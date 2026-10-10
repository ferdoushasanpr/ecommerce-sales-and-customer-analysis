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

----------------------------------------------------------------------------------------What percentage of total revenue comes from each category?

SELECT
    p.Category,
    SUM(oi.Quantity * oi.PricePerUnit) AS Revenue,
    SUM(oi.Quantity * oi.PricePerUnit) * 100.0 /
        (
            SELECT SUM(oi2.Quantity * oi2.PricePerUnit)
            FROM EcommerceDB.dbo.Order_Items AS oi2
            INNER JOIN EcommerceDB.dbo.Orders AS o2
                ON oi2.OrderID = o2.OrderID
            WHERE o2.OrderStatus = 'Delivered'
        ) AS RevenuePercentage
FROM EcommerceDB.dbo.Order_Items AS oi
INNER JOIN EcommerceDB.dbo.Products AS p
    ON oi.ProductID = p.ProductID
INNER JOIN EcommerceDB.dbo.Orders AS o
    ON oi.OrderID = o.OrderID
WHERE o.OrderStatus = 'Delivered'
GROUP BY p.Category
ORDER BY Revenue DESC;


----------------------------------------------------------------------------------------How much units sold per product in the last 6 months?

SELECT
        oi.ProductID,
        YEAR(o.OrderDate) AS SalesYear,
        DATENAME(MONTH, o.OrderDate) AS SalesMonth,
        SUM(oi.Quantity) AS MonthlyUnitsSold
    FROM dbo.Orders AS o
    INNER JOIN dbo.Order_Items AS oi
        ON o.OrderID = oi.OrderID
    WHERE o.OrderDate >= DATEADD(MONTH, -6, CAST(GETDATE() AS date))
    GROUP BY
        oi.ProductID,
        YEAR(o.OrderDate),
        MONTH(o.OrderDate),
        DATENAME(MONTH, o.OrderDate)
        
        
----------------------------------------------------------------------------------------Which products rank highest within each category?

WITH   ProductCategoryQuantity
AS     (SELECT   [p].[ProductID],
                 [p].[ProductName],
                 [P].[Category],
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
        GROUP BY [p].[ProductID], [p].[ProductName], [P].[Category])
SELECT [ProductID],
       [ProductName],
       [Category],
       [TotalQty],
       DENSE_RANK() OVER (PARTITION BY [Category] ORDER BY [TotalQty] DESC) AS [Rank],
       [Revenue]
FROM   ProductCategoryQuantity;


----------------------------------------------------------------------------------------Which product combinations are frequently purchased together?


SELECT   [A].[ProductID] AS [Product1],
[P1].[ProductName] AS [Product1],
         [B].[ProductID] AS [Product2],
         [P2].[ProductName] AS [Product2],
         COUNT(DISTINCT [A].[OrderID]) AS [OrdersTogether]
FROM     [dbo].[Order_Items] AS [A]
         INNER JOIN
         [dbo].[Order_Items] AS [B]
         ON [A].[OrderID] = [B].[OrderID]
            AND [A].[ProductID] < [B].[ProductID] INNER JOIN [EcommerceDB].[dbo].[Products] AS [P1]
    ON [A].[ProductID] = [P1].[ProductID]
INNER JOIN [EcommerceDB].[dbo].[Products] AS [P2]
    ON [B].[ProductID] = [P2].[ProductID]
GROUP BY [A].[ProductID], [P1].[ProductName], [B].[ProductID], [P2].[ProductName]
ORDER BY [OrdersTogether] DESC;
