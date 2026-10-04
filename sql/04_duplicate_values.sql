----------Customers — duplicate CustomerID

SELECT 
    CustomerID,
    COUNT(*) AS DuplicateCount
FROM dbo.Customers
GROUP BY CustomerID
HAVING COUNT(*) > 1;


----------Customers — duplicate email addresses

SELECT 
    Email,
    COUNT(*) AS DuplicateCount
FROM dbo.Customers
GROUP BY Email
HAVING COUNT(*) > 1;


----------Products — duplicate ProductID

SELECT 
    ProductID,
    COUNT(*) AS DuplicateCount
FROM dbo.Products
GROUP BY ProductID
HAVING COUNT(*) > 1;


----------Orders — duplicate OrderID

SELECT 
    OrderID,
    COUNT(*) AS DuplicateCount
FROM dbo.Orders
GROUP BY OrderID
HAVING COUNT(*) > 1;


----------Order_Items — duplicate OrderItemID

SELECT 
    OrderItemID,
    COUNT(*) AS DuplicateCount
FROM dbo.Order_Items
GROUP BY OrderItemID
HAVING COUNT(*) > 1;


----------Inventory — duplicate InventoryID

SELECT 
    InventoryID,
    COUNT(*) AS DuplicateCount
FROM dbo.Inventory
GROUP BY InventoryID
HAVING COUNT(*) > 1;


----------Inventory — duplicate Product/Warehouse combinations

SELECT 
    ProductID,
    Warehouse,
    COUNT(*) AS DuplicateCount
FROM dbo.Inventory
GROUP BY 
    ProductID,
    Warehouse
HAVING COUNT(*) > 1;


----------Duplicate OrderID + ProductID combinations

SELECT
    OrderID,
    ProductID,
    COUNT(*) AS ItemCount
FROM dbo.Order_Items
GROUP BY
    OrderID,
    ProductID
HAVING COUNT(*) > 1;

