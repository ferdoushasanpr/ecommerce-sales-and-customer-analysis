CREATE VIEW vw_OrderDetails AS
SELECT
    o.OrderID,
    o.OrderDate,
    o.CustomerID,
    c.FullName,
    c.City,
    c.Country,
    o.OrderStatus,
    oi.OrderItemID,
    oi.ProductID,
    p.ProductName,
    p.Category,
    p.Brand,
    oi.Quantity,
    oi.PricePerUnit,
    oi.Quantity * oi.PricePerUnit AS LineTotal
FROM Orders o
JOIN Customers c
    ON o.CustomerID = c.CustomerID
JOIN Order_Items oi
    ON o.OrderID = oi.OrderID
JOIN Products p
    ON oi.ProductID = p.ProductID;
