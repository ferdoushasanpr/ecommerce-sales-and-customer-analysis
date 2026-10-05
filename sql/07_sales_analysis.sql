---------------------------------------------------------------------------------------How many orders were placed?

SELECT   [OrderStatus],
         COUNT([OrderID]) AS [CountOrders]
FROM     [EcommerceDB].[dbo].[Orders]
GROUP BY [OrderStatus];

----------------------------------------------------------------------------------------What is the total revenue?

SELECT
    SUM(TotalAmount) AS TotalRevenue
FROM EcommerceDB.dbo.Orders
WHERE OrderStatus = 'Delivered';

----------------------------------------------------------------------------------------What is the monetary value per order status?

SELECT   [OrderStatus],
         COUNT([OrderID]) AS [CountOrders],
         SUM([TotalAmount]) AS [Revenue],
         AVG([TotalAmount]) AS [AverageOrderValue]
FROM     [EcommerceDB].[dbo].[Orders]
GROUP BY [OrderStatus];

----------------------------------------------------------------------------------------What are the total revenue and average order value (AOV)?

SELECT COUNT([OrderID]) AS [TotalOrders]
      ,SUM([TotalAmount]) AS [Revenue]
      ,AVG([TotalAmount]) AS [AOV]
  FROM [EcommerceDB].[dbo].[Orders] WHERE [OrderStatus] = 'Delivered';

----------------------------------------------------------------------------------------What are the first and last order date?

SELECT
    MIN([OrderDate]) AS [FirstOrderDate],
    MAX([OrderDate]) AS [LastOrderDate]
FROM dbo.Orders;

----------------------------------------------------------------------------------------How much products contains in each category?

SELECT [Category]
      ,COUNT([ProductID]) AS [TotalProduct]
  FROM [EcommerceDB].[dbo].[Products] GROUP BY [Category];

----------------------------------------------------------------------------------------What is the revenue by year?

SELECT YEAR([OrderDate]) AS [Year]
      ,COUNT([OrderID]) AS [TotalOrders]
      ,SUM([TotalAmount]) AS [Revenue]
  FROM [EcommerceDB].[dbo].[Orders] WHERE [OrderStatus] = 'Delivered' GROUP BY YEAR([OrderDate]);
  
----------------------------------------------------------------------------------------What is the revenue by month?

SELECT   YEAR([OrderDate]) AS [Year],
         DATENAME(MONTH, [OrderDate]) AS [Month],
         COUNT([OrderID]) AS [TotalOrders],
         SUM([TotalAmount]) AS [Revenue]
FROM     [EcommerceDB].[dbo].[Orders] WHERE [OrderStatus] = 'Delivered'
GROUP BY YEAR([OrderDate]), MONTH([OrderDate]), DATENAME(MONTH, [OrderDate])
ORDER BY YEAR([OrderDate]), MONTH([OrderDate]);

----------------------------------------------------------------------------------------What is the revenue change by month?

WITH MonthlyRevenue AS
(
    SELECT
        YEAR(OrderDate) AS [Year],
        MONTH(OrderDate) AS [MonthNumber],
        DATENAME(MONTH, OrderDate) AS [Month],
        COUNT(OrderID) AS [TotalOrders],
        SUM(TotalAmount) AS [Revenue]
    FROM EcommerceDB.dbo.Orders
    WHERE OrderStatus = 'Delivered'
    GROUP BY
        YEAR(OrderDate),
        MONTH(OrderDate),
        DATENAME(MONTH, OrderDate)
)
SELECT
    [Year],
    [Month],
    [TotalOrders],
    [Revenue],
    LAG([Revenue]) OVER (
        ORDER BY [Year], [MonthNumber]
    ) AS [PreviousRevenue],
    [Revenue] -
        LAG([Revenue]) OVER (
            ORDER BY [Year], [MonthNumber]
        ) AS [RevenueChange]
FROM MonthlyRevenue
ORDER BY [Year], [MonthNumber];

----------------------------------------------------------------------------------------What is the month-over-month revenue growth?

WITH MonthlyRevenue AS
(
    SELECT
        YEAR(OrderDate) AS [Year],
        MONTH(OrderDate) AS [MonthNumber],
        DATENAME(MONTH, OrderDate) AS [Month],
        COUNT(OrderID) AS [Orders],
        COUNT(DISTINCT CustomerID) AS [Customers],
        SUM(TotalAmount) AS [Revenue],
        AVG(TotalAmount) AS [AOV]
    FROM EcommerceDB.dbo.Orders
    WHERE OrderStatus = 'Delivered'
    GROUP BY
        YEAR(OrderDate),
        MONTH(OrderDate),
        DATENAME(MONTH, OrderDate)
)
SELECT
    [Year],
    [Month],
    [Orders],
    [Customers],
    [Revenue],
    [AOV],
    (
        [Revenue] -
        LAG([Revenue]) OVER (
            ORDER BY [Year], [MonthNumber]
        )
    )
    /
    NULLIF(
        LAG([Revenue]) OVER (
            ORDER BY [Year], [MonthNumber]
        ),
        0
    ) * 100 AS [MoM Growth %]
FROM MonthlyRevenue
ORDER BY [Year], [MonthNumber];

----------------------------------------------------------------------------------------What is the 3-Month Rolling Avg Revenue?

WITH     MonthlyRevenue
AS       (SELECT   YEAR(OrderDate) AS [Year],
                   MONTH(OrderDate) AS [MonthNumber],
                   DATENAME(MONTH, OrderDate) AS [Month],
                   COUNT(OrderID) AS [Orders],
                   COUNT(DISTINCT CustomerID) AS [Customers],
                   SUM(TotalAmount) AS [Revenue],
                   AVG(TotalAmount) AS [AOV]
          FROM     EcommerceDB.dbo.Orders
          WHERE    OrderStatus = 'Delivered'
          GROUP BY YEAR(OrderDate), MONTH(OrderDate), DATENAME(MONTH, OrderDate)),
         RevenueWithPreviousMonth
AS       (SELECT [Year],
                 [MonthNumber],
                 [Month],
                 [Orders],
                 [Customers],
                 [Revenue],
                 [AOV],
                 LAG([Revenue]) OVER (ORDER BY [Year], [MonthNumber]) AS [PreviousMonthRevenue]
          FROM   MonthlyRevenue)
SELECT   [Year],
         [Month],
         [Revenue],
         [PreviousMonthRevenue],
         (([Revenue] - [PreviousMonthRevenue]) / NULLIF ([PreviousMonthRevenue], 0)) * 100 AS [MoM Growth %],
         AVG([Revenue]) OVER (ORDER BY [Year], [MonthNumber] ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS [3-Month Rolling Avg Revenue]
FROM     RevenueWithPreviousMonth
ORDER BY [Year], [MonthNumber];

-----------------------------------------------------------------------------------------Which product categories generate the most revenue?

SELECT   p.Category,
         SUM(oi.Quantity) AS [TotalQty],
         sum(oi.Quantity * oi.PricePerUnit) AS [Revenue]
FROM     Orders AS o
         INNER JOIN
         Order_Items AS oi
         ON o.OrderID = oi.OrderID
         INNER JOIN
         Products AS p
         ON oi.ProductID = p.ProductID WHERE o.OrderStatus = 'Delivered'
GROUP BY p.Category ORDER BY [Revenue] DESC;

------------------------------------------------------------------------------------------Which brands generate the most revenue?

SELECT   p.Brand,
         SUM(oi.Quantity) AS [TotalQty],
         sum(oi.Quantity * oi.PricePerUnit) AS [Revenue]
FROM     Orders AS o
         INNER JOIN
         Order_Items AS oi
         ON o.OrderID = oi.OrderID
         INNER JOIN
         Products AS p
         ON oi.ProductID = p.ProductID WHERE o.OrderStatus = 'Delivered'
GROUP BY p.Brand ORDER BY [Revenue] DESC;
