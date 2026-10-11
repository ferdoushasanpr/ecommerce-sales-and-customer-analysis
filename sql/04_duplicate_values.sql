/* ------------------------------------------------------------
   1. Duplicate customer IDs
   ------------------------------------------------------------ */

SELECT 
    CustomerID,
    COUNT(*) AS DuplicateCount
FROM dbo.Customers
GROUP BY CustomerID
HAVING COUNT(*) > 1;


/* ------------------------------------------------------------
   2. Duplicate customer email addresses
   ------------------------------------------------------------ */

SELECT 
    Email,
    COUNT(*) AS DuplicateCount
FROM dbo.Customers
GROUP BY Email
HAVING COUNT(*) > 1;


/* ------------------------------------------------------------
   3. Duplicate product IDs
   ------------------------------------------------------------ */

SELECT 
    ProductID,
    COUNT(*) AS DuplicateCount
FROM dbo.Products
GROUP BY ProductID
HAVING COUNT(*) > 1;


/* ------------------------------------------------------------
   4. Duplicate order IDs
   ------------------------------------------------------------ */

SELECT 
    OrderID,
    COUNT(*) AS DuplicateCount
FROM dbo.Orders
GROUP BY OrderID
HAVING COUNT(*) > 1;


/* ------------------------------------------------------------
   5. Duplicate order-item IDs
   ------------------------------------------------------------ */

SELECT 
    OrderItemID,
    COUNT(*) AS DuplicateCount
FROM dbo.Order_Items
GROUP BY OrderItemID
HAVING COUNT(*) > 1;


/* ------------------------------------------------------------
   6. Duplicate Inventory IDs
   ------------------------------------------------------------ */

SELECT 
    InventoryID,
    COUNT(*) AS DuplicateCount
FROM dbo.Inventory
GROUP BY InventoryID
HAVING COUNT(*) > 1;


/* ------------------------------------------------------------
   7. Duplicate Inventory Product/Warehouse combinations
   ------------------------------------------------------------ */

SELECT 
    ProductID,
    Warehouse,
    COUNT(*) AS DuplicateCount
FROM dbo.Inventory
GROUP BY 
    ProductID,
    Warehouse
HAVING COUNT(*) > 1;


/* ------------------------------------------------------------
   8. Duplicate OrderID + ProductID combinations
   ------------------------------------------------------------ */

SELECT
    OrderID,
    ProductID,
    COUNT(*) AS ItemCount
FROM dbo.Order_Items
GROUP BY
    OrderID,
    ProductID
HAVING COUNT(*) > 1;

