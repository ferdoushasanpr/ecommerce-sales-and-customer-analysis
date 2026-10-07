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

----------------------------------------------------------------------------------------Which countries/cities generate the most revenue?

SELECT
    c.Country,
    c.City,
    COUNT(DISTINCT o.OrderID) AS TotalOrders,
    SUM(o.TotalAmount) AS Revenue
FROM EcommerceDB.dbo.Orders AS o
INNER JOIN EcommerceDB.dbo.Customers AS c
    ON o.CustomerID = c.CustomerID
WHERE o.OrderStatus = 'Delivered'
GROUP BY
    c.Country,
    c.City
ORDER BY
    Revenue DESC;
    
----------------------------------------------------------------------------------------How many customers registered but have not ordered?

SELECT
    COUNT(DISTINCT CASE
        WHEN [o].[OrderID] IS NOT NULL THEN [c].[CustomerID]
    END) AS [Ordered],
    COUNT(DISTINCT CASE
        WHEN [o].[OrderID] IS NULL THEN [c].[CustomerID]
    END) AS [NotOrderedYet]
FROM [EcommerceDB].[dbo].[Customers] AS [c]
LEFT JOIN [EcommerceDB].[dbo].[Orders] AS [o]
    ON [c].[CustomerID] = [o].[CustomerID];
    
----------------------------------------------------------------------------------------Which customers registered but never placed an order?

SELECT [c].[CustomerID],
       [FullName],
       [Email],
       [SignUpDate],
       [City],
       [Country],
       DATEDIFF(
        DAY,
        [c].[SignUpDate],
        CAST(GETDATE() AS DATE)
    ) AS [DaysSinceSignup]
FROM   [EcommerceDB].[dbo].[Orders] AS o
       RIGHT OUTER JOIN
       [EcommerceDB].[dbo].[Customers] AS c
       ON [o].[CustomerID] = [c].[CustomerID]
WHERE  [OrderID] IS NULL;

----------------------------------------------------------------------------------------How can customers be segmented based on spending?

WITH CustomerRFM AS
(
    SELECT
        c.CustomerID,
        c.FullName,

        DATEDIFF(
            DAY,
            MAX(o.OrderDate),
            CAST(GETDATE() AS DATE)
        ) AS Recency,

        COUNT(DISTINCT o.OrderID) AS Frequency,

        SUM(o.TotalAmount) AS Monetary

    FROM EcommerceDB.dbo.Customers AS c
    INNER JOIN EcommerceDB.dbo.Orders AS o
        ON c.CustomerID = o.CustomerID

    WHERE o.OrderStatus = 'Delivered'

    GROUP BY
        c.CustomerID,
        c.FullName
)
SELECT
    *,
    NTILE(5) OVER (
        ORDER BY Recency DESC
    ) AS RecencyScore,

    NTILE(5) OVER (
        ORDER BY Frequency
    ) AS FrequencyScore,

    NTILE(5) OVER (
        ORDER BY Monetary
    ) AS MonetaryScore

FROM CustomerRFM;

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------

WITH CustomerRFM AS
(
    SELECT
        c.CustomerID,
        c.FullName,

        DATEDIFF(
            DAY,
            MAX(o.OrderDate),
            CAST(GETDATE() AS DATE)
        ) AS Recency,

        COUNT(DISTINCT o.OrderID) AS Frequency,

        SUM(o.TotalAmount) AS Monetary

    FROM EcommerceDB.dbo.Customers AS c
    INNER JOIN EcommerceDB.dbo.Orders AS o
        ON c.CustomerID = o.CustomerID

    WHERE o.OrderStatus = 'Delivered'

    GROUP BY
        c.CustomerID,
        c.FullName
),
RFMScores AS
(
    SELECT
        *,
        NTILE(5) OVER (
            ORDER BY Recency DESC
        ) AS RecencyScore,

        NTILE(5) OVER (
            ORDER BY Frequency
        ) AS FrequencyScore,

        NTILE(5) OVER (
            ORDER BY Monetary
        ) AS MonetaryScore
    FROM CustomerRFM
)
SELECT
    *,
    RecencyScore
        + FrequencyScore
        + MonetaryScore AS RFMScore
FROM RFMScores
ORDER BY RFMScore DESC;

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------

WITH CustomerRFM AS
(
    SELECT
        c.CustomerID,
        c.FullName,

        DATEDIFF(
            DAY,
            MAX(o.OrderDate),
            CAST(GETDATE() AS DATE)
        ) AS Recency,

        COUNT(DISTINCT o.OrderID) AS Frequency,

        SUM(o.TotalAmount) AS Monetary

    FROM EcommerceDB.dbo.Customers AS c
    INNER JOIN EcommerceDB.dbo.Orders AS o
        ON c.CustomerID = o.CustomerID

    WHERE o.OrderStatus = 'Delivered'

    GROUP BY
        c.CustomerID,
        c.FullName
),
RFMScores AS
(
    SELECT
        *,
        NTILE(5) OVER (ORDER BY Recency DESC) AS RecencyScore,
        NTILE(5) OVER (ORDER BY Frequency) AS FrequencyScore,
        NTILE(5) OVER (ORDER BY Monetary) AS MonetaryScore
    FROM CustomerRFM
),
FinalRFM AS
(
    SELECT
        *,
        RecencyScore
        + FrequencyScore
        + MonetaryScore AS RFMScore
    FROM RFMScores
)
SELECT
    CustomerID,
    FullName,
    Recency,
    Frequency,
    Monetary,
    RecencyScore,
    FrequencyScore,
    MonetaryScore,
    RFMScore,

    CASE
    WHEN RecencyScore >= 4
         AND FrequencyScore >= 4
         AND MonetaryScore >= 4
        THEN 'High Value'

    WHEN RecencyScore >= 4
         AND FrequencyScore >= 3
        THEN 'Loyal Customers'

    WHEN RecencyScore <= 2
         AND FrequencyScore >= 3
        THEN 'At Risk'

    WHEN RecencyScore >= 4
         AND FrequencyScore <= 2
        THEN 'New / Promising'

    ELSE 'Occasional Customers'
END AS CustomerSegment

FROM FinalRFM
ORDER BY RFMScore DESC;

----------------------------------------------------------------------------------------What are the customer details, first and last order dates, number of days since their last order, total number of orders, and total revenue generated?

SELECT   [c].[CustomerID],
         [FullName],
         [Email],
         [SignUpDate],
         MIN([OrderDate]) AS [FirstOrderDate],
         MAX([OrderDate]) AS [LastOrderDate],
         DATEDIFF(DAY, MAX([OrderDate]), CAST (GETDATE() AS DATE)) AS [DaysSinceLastOrder],
         [City],
         COUNT([OrderID]) AS [TotalOrders],
         SUM([TotalAmount]) AS [TotalRevenue]
FROM     [EcommerceDB].[dbo].[Customers] AS c
         INNER JOIN
         [EcommerceDB].[dbo].[Orders] AS o
         ON [c].[CustomerID] = [o].[CustomerID]
GROUP BY [c].[CustomerID], [FullName], [Email], [SignUpDate], [City];

----------------------------------------------------------------------------------------How many of the customers placed an order during their signup month?


SELECT
    YEAR(c.SignUpDate) AS [Year],
    DATENAME(MONTH, c.SignUpDate) AS [Month],
    COUNT(DISTINCT c.CustomerID) AS [TotalCustomers],
    COUNT(DISTINCT CASE
        WHEN YEAR(c.SignUpDate) = YEAR(o.OrderDate)
         AND MONTH(c.SignUpDate) = MONTH(o.OrderDate)
        THEN c.CustomerID
    END) AS [CustomersOrderedDuringSignupMonth]
FROM EcommerceDB.dbo.Customers AS c
LEFT JOIN EcommerceDB.dbo.Orders AS o
    ON c.CustomerID = o.CustomerID
GROUP BY
    YEAR(c.SignUpDate),
    MONTH(c.SignUpDate),
    DATENAME(MONTH, c.SignUpDate)
ORDER BY
    [Year],
    MONTH(c.SignUpDate);
    
----------------------------------------------------------------------------------------How long does a customer not order since their most recent order?

WITH CustomerMetrics AS
(
    SELECT
        c.CustomerID,
        c.FullName,
        c.email,
        c.City,
        c.Country,
        COUNT(o.OrderID) AS TotalOrders,
        SUM(o.TotalAmount) AS TotalRevenue,
        AVG(o.TotalAmount) AS AverageOrderValue,
        c.SignUpDate,
        MIN(o.OrderDate) AS FirstOrderDate,
        MAX(o.OrderDate) AS LastOrderDate
    FROM EcommerceDB.dbo.Customers AS c
    INNER JOIN EcommerceDB.dbo.Orders AS o
        ON c.CustomerID = o.CustomerID
    WHERE o.OrderStatus = 'Delivered'
    GROUP BY
        c.CustomerID,
        c.FullName,
        c.email,
        c.City,
        c.Country,
        c.SignUpDate
)
SELECT
    *,
    DATEDIFF(
        DAY,
        LastOrderDate,
        CAST(GETDATE() AS DATE)
    ) AS DaysSinceLastOrder
FROM CustomerMetrics
ORDER BY TotalRevenue DESC;


