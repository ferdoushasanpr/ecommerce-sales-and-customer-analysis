/* ------------------------------------------------------------
   1. Check for invalid email address
   ------------------------------------------------------------ */
SELECT *
FROM dbo.Customers
WHERE Email LIKE '% %'
   OR Email LIKE '%..%'
   OR Email LIKE '@%'
   OR Email LIKE '%@%@%';


/* ------------------------------------------------------------
   2. Check for invalid product prices
   ------------------------------------------------------------ */
SELECT *
FROM dbo.Products
WHERE UnitPrice < 0;


SELECT *
FROM dbo.Products
WHERE UnitPrice = 0;


SELECT *
FROM dbo.Products
WHERE UnitPrice > 100000;


/* ------------------------------------------------------------
   3. Check for invalid order-item quantities
   ------------------------------------------------------------ */
SELECT *
FROM dbo.Order_Items
WHERE Quantity <= 0;


SELECT *
FROM dbo.Order_Items
WHERE PricePerUnit < 0;

SELECT *
FROM dbo.Order_Items
WHERE PricePerUnit = 0;


/* ------------------------------------------------------------
   4. Check for invalid order amounts
   ------------------------------------------------------------ */
SELECT *
FROM dbo.Orders
WHERE TotalAmount < 0;

SELECT *
FROM dbo.Orders
WHERE TotalAmount = 0;


/* ------------------------------------------------------------
   5. Check for invalid stock quantity
   ------------------------------------------------------------ */
SELECT *
FROM dbo.Inventory
WHERE StockQuantity < 0;


/* ------------------------------------------------------------
   6. Check for invalid order and signup dates
   ------------------------------------------------------------ */
SELECT 
    o.OrderID,
    o.CustomerID,
    o.OrderDate,
    c.SignUpDate
FROM dbo.Orders o
JOIN dbo.Customers c
    ON o.CustomerID = c.CustomerID
WHERE o.OrderDate < c.SignUpDate;


/* ------------------------------------------------------------
   7. Check for inconsistent product prices across order items
   Compare historical order-item prices for each product.
   ------------------------------------------------------------ */
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


/* ------------------------------------------------------------
   8. Check for orders without order items
   ------------------------------------------------------------ */
SELECT o.*
FROM dbo.Orders o
LEFT JOIN dbo.Order_Items oi
    ON o.OrderID = oi.OrderID
WHERE oi.OrderID IS NULL;


/* ------------------------------------------------------------
   9. Check for order items without matching orders
   ------------------------------------------------------------ */
SELECT oi.*
FROM dbo.Order_Items oi
LEFT JOIN dbo.Orders o
    ON oi.OrderID = o.OrderID
WHERE o.OrderID IS NULL;


/* ------------------------------------------------------------
   10. Check for products without inventory records
   ------------------------------------------------------------ */
SELECT p.*
FROM dbo.Products p
LEFT JOIN dbo.Inventory i
    ON p.ProductID = i.ProductID
WHERE i.ProductID IS NULL;


/* ------------------------------------------------------------
   11. Count orphan records across related tables
   ------------------------------------------------------------ */
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


/* ------------------------------------------------------------
   12. Revenue reconciliation
   Compare order-level amount with calculated line-item amount.
   ------------------------------------------------------------ */
SELECT
    o.OrderID,
    o.TotalAmount AS OrderTotal,
    SUM(oi.Quantity * oi.PricePerUnit) AS CalculatedTotal,
    o.TotalAmount
        - SUM(oi.Quantity * oi.PricePerUnit) AS Difference
FROM dbo.Orders AS o
INNER JOIN dbo.Order_Items AS oi
    ON o.OrderID = oi.OrderID
GROUP BY
    o.OrderID,
    o.TotalAmount
HAVING
    ABS(
        o.TotalAmount
        - SUM(oi.Quantity * oi.PricePerUnit)
    ) > 0.01
ORDER BY
    ABS(
        o.TotalAmount
        - SUM(oi.Quantity * oi.PricePerUnit)
    ) DESC;
