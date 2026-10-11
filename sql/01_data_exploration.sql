/* ============================================================
   01 - DATA QUALITY & DATA PROFILING
   ============================================================ */


/* ------------------------------------------------------------
   1. Row counts by table
   ------------------------------------------------------------ */

SELECT 'Customers' AS TableName, COUNT(*) AS RowCount
FROM dbo.Customers

UNION ALL

SELECT 'Products', COUNT(*)
FROM dbo.Products

UNION ALL

SELECT 'Orders', COUNT(*)
FROM dbo.Orders

UNION ALL

SELECT 'Order_Items', COUNT(*)
FROM dbo.Order_Items

UNION ALL

SELECT 'Inventory', COUNT(*)
FROM dbo.Inventory;


/* ------------------------------------------------------------
   2. Unique customer count
   ------------------------------------------------------------ */
SELECT COUNT(DISTINCT [CustomerID]) AS [TotalCustomers]
  FROM [EcommerceDB].[dbo].[Customers];


/* ------------------------------------------------------------
   3. Unique product count
   ------------------------------------------------------------ */
SELECT COUNT(DISTINCT [ProductID]) AS [TotalProducts]
FROM [EcommerceDB].[dbo].[Products];


/* ------------------------------------------------------------
   4. Unique order count
   ------------------------------------------------------------ */
SELECT COUNT(DISTINCT [OrderID]) AS [TotalOrders]
FROM [EcommerceDB].[dbo].[Orders];


/* ------------------------------------------------------------
   5. Unique order-item count
   ------------------------------------------------------------ */
SELECT COUNT(DISTINCT [OrderItemID]) AS [TotalOrderItems]
FROM [EcommerceDB].[dbo].[Order_Items];


/* ------------------------------------------------------------
   6. Unique inventory record count
   ------------------------------------------------------------ */
SELECT COUNT(DISTINCT [InventoryID]) AS [TotalInventory]
FROM [EcommerceDB].[dbo].[Inventory];


/* ------------------------------------------------------------
   7. NULL check - Customers
   ------------------------------------------------------------ */
SELECT COUNT([CustomerID]) AS [TotalCustomerID]
      ,COUNT([FullName]) AS [TotalFullName]
      ,COUNT([Email]) AS [TotalEmail]
      ,COUNT([SignUpDate]) AS [TotalSignUpDate]
      ,COUNT([City]) AS [TotalCity]
      ,COUNT([Country]) AS [TotalCountry]
  FROM [EcommerceDB].[dbo].[Customers]
  
  
/* ------------------------------------------------------------
   8. NULL check - Products
   ------------------------------------------------------------ */
SELECT COUNT([ProductID]) AS [TotalProductID],
       COUNT([ProductName]) AS [TotalProductName],
       COUNT([Category]) AS [TotalCategory],
       COUNT([Brand]) AS [TotalBrand],
       COUNT([UnitPrice]) AS [TotalUnitPrice]
FROM [EcommerceDB].[dbo].[Products];


/* ------------------------------------------------------------
   9. NULL check - Orders
   ------------------------------------------------------------ */
SELECT COUNT([OrderID]) AS [TotalOrderID],
       COUNT([CustomerID]) AS [TotalCustomerID],
       COUNT([OrderDate]) AS [TotalOrderDate],
       COUNT([OrderStatus]) AS [TotalOrderStatus],
       COUNT([TotalAmount]) AS [TotalAmount]
FROM [EcommerceDB].[dbo].[Orders];


/* ------------------------------------------------------------
   10. NULL check - Order Items
   ------------------------------------------------------------ */
SELECT COUNT([OrderItemID]) AS [TotalOrderItemID],
       COUNT([OrderID]) AS [TotalOrderID],
       COUNT([ProductID]) AS [TotalProductID],
       COUNT([Quantity]) AS [TotalQuantity],
       COUNT([PricePerUnit]) AS [TotalPricePerUnit]
FROM [EcommerceDB].[dbo].[Order_Items];


/* ------------------------------------------------------------
   11. NULL check - Inventory
   ------------------------------------------------------------ */
SELECT COUNT([InventoryID]) AS [TotalInventoryID],
       COUNT([ProductID]) AS [TotalProductID],
       COUNT([Warehouse]) AS [TotalWarehouse],
       COUNT([StockQuantity]) AS [TotalStockQuantity]
FROM [EcommerceDB].[dbo].[Inventory];
