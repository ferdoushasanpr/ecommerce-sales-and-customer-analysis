----------Orders → Customers

SELECT o.*
FROM dbo.Orders o
LEFT JOIN dbo.Customers c
    ON o.CustomerID = c.CustomerID
WHERE c.CustomerID IS NULL;


----------Order_Items → Orders

SELECT oi.*
FROM dbo.Order_Items oi
LEFT JOIN dbo.Orders o
    ON oi.OrderID = o.OrderID
WHERE o.OrderID IS NULL;


----------Order_Items → Products

SELECT oi.*
FROM dbo.Order_Items oi
LEFT JOIN dbo.Products p
    ON oi.ProductID = p.ProductID
WHERE p.ProductID IS NULL;


----------Inventory → Products

SELECT i.*
FROM dbo.Inventory i
LEFT JOIN dbo.Products p
    ON i.ProductID = p.ProductID
WHERE p.ProductID IS NULL;
