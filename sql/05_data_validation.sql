SELECT *
FROM dbo.Customers
WHERE Email LIKE '% %'
   OR Email LIKE '%..%'
   OR Email LIKE '@%'
   OR Email LIKE '%@%@%';

SELECT *
FROM dbo.Products
WHERE UnitPrice < 0;


SELECT *
FROM dbo.Products
WHERE UnitPrice = 0;


SELECT *
FROM dbo.Products
WHERE UnitPrice > 100000;


SELECT *
FROM dbo.Order_Items
WHERE Quantity <= 0;


SELECT *
FROM dbo.Order_Items
WHERE PricePerUnit < 0;

SELECT *
FROM dbo.Order_Items
WHERE PricePerUnit = 0;


SELECT *
FROM dbo.Orders
WHERE TotalAmount < 0;


SELECT *
FROM dbo.Orders
WHERE TotalAmount = 0;


SELECT *
FROM dbo.Inventory
WHERE StockQuantity < 0;


SELECT 
    o.OrderID,
    o.CustomerID,
    o.OrderDate,
    c.SignUpDate
FROM dbo.Orders o
JOIN dbo.Customers c
    ON o.CustomerID = c.CustomerID
WHERE o.OrderDate < c.SignUpDate;

SELECT 
    oi.ProductID,
    p.ProductName,
    p.UnitPrice AS CurrentProductPrice,
    MIN(oi.PricePerUnit) AS MinimumOrderPrice,
    MAX(oi.PricePerUnit) AS MaximumOrderPrice
FROM dbo.Order_Items oi
JOIN dbo.Products p
    ON oi.ProductID = p.ProductID
GROUP BY 
    oi.ProductID,
    p.ProductName,
    p.UnitPrice
HAVING MIN(oi.PricePerUnit) <> MAX(oi.PricePerUnit);


SELECT o.*
FROM dbo.Orders o
LEFT JOIN dbo.Order_Items oi
    ON o.OrderID = oi.OrderID
WHERE oi.OrderID IS NULL;

SELECT oi.*
FROM dbo.Order_Items oi
LEFT JOIN dbo.Orders o
    ON oi.OrderID = o.OrderID
WHERE o.OrderID IS NULL;

SELECT p.*
FROM dbo.Products p
LEFT JOIN dbo.Inventory i
    ON p.ProductID = i.ProductID
WHERE i.ProductID IS NULL;

SELECT 'Orders without Customers' AS CheckName,
       COUNT(*) AS ErrorCount
FROM dbo.Orders o
LEFT JOIN dbo.Customers c
    ON o.CustomerID = c.CustomerID
WHERE c.CustomerID IS NULL

UNION ALL

SELECT 'Order Items without Orders',
       COUNT(*)
FROM dbo.Order_Items oi
LEFT JOIN dbo.Orders o
    ON oi.OrderID = o.OrderID
WHERE o.OrderID IS NULL

UNION ALL

SELECT 'Order Items without Products',
       COUNT(*)
FROM dbo.Order_Items oi
LEFT JOIN dbo.Products p
    ON oi.ProductID = p.ProductID
WHERE p.ProductID IS NULL

UNION ALL

SELECT 'Inventory without Products',
       COUNT(*)
FROM dbo.Inventory i
LEFT JOIN dbo.Products p
    ON i.ProductID = p.ProductID
WHERE p.ProductID IS NULL;


SELECT
    o.OrderID,
    o.TotalAmount AS OrderTotal,
    SUM(oi.Quantity * oi.PricePerUnit) AS CalculatedTotal,
    o.TotalAmount - SUM(oi.Quantity * oi.PricePerUnit) AS Difference
FROM EcommerceDB.dbo.Orders AS o
INNER JOIN EcommerceDB.dbo.Order_Items AS oi
    ON o.OrderID = oi.OrderID
GROUP BY
    o.OrderID,
    o.TotalAmount
HAVING
    ABS(
        o.TotalAmount - SUM(oi.Quantity * oi.PricePerUnit)
    ) > 0.01
ORDER BY
    ABS(o.TotalAmount - SUM(oi.Quantity * oi.PricePerUnit)) DESC;