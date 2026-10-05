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

----------------------------------------------------------------------------------------Which customers are repeat buyers?

SELECT   [c].[CustomerID],
         [c].[FullName],
         COUNT([o].[OrderID]) AS [TotalOrders],
         SUM([o].[TotalAmount]) AS [Revenue]
FROM     [EcommerceDB].[dbo].[Orders] AS o
         INNER JOIN
         [EcommerceDB].[dbo].[Customers] AS c
         ON [o].[CustomerID] = [c].[CustomerID]
WHERE    [o].[OrderStatus] = 'Delivered'
GROUP BY [c].[CustomerID], [c].[FullName]
HAVING   COUNT([o].[OrderID]) > 1
ORDER BY [Revenue] DESC;

----------------------------------------------------------------------------------------What percentage of customers are repeat buyers?

WITH CustomerOrders AS
(
    SELECT
        c.CustomerID,
        COUNT(DISTINCT o.OrderID) AS TotalOrders
    FROM EcommerceDB.dbo.Customers AS c
    LEFT JOIN EcommerceDB.dbo.Orders AS o
        ON c.CustomerID = o.CustomerID
       AND o.OrderStatus = 'Delivered'
    GROUP BY c.CustomerID
)
SELECT
    COUNT(*) AS TotalCustomers,

    SUM(
        CASE
            WHEN TotalOrders > 1 THEN 1
            ELSE 0
        END
    ) AS RepeatCustomers,

    SUM(
        CASE
            WHEN TotalOrders > 1 THEN 1
            ELSE 0
        END
    ) * 100.0 / COUNT(*) AS RepeatCustomerPercentage

FROM CustomerOrders;
