-- Total number of unique customers
SELECT COUNT(DISTINCT [CustomerID]) AS [TotalCustomers]
  FROM [EcommerceDB].[dbo].[Customers];


-- Count of non-NULL values in each column
SELECT COUNT([CustomerID]) AS [TotalCustomerID]
      ,COUNT([FullName]) AS [TotalFullName]
      ,COUNT([Email]) AS [TotalEmail]
      ,COUNT([SignUpDate]) AS [TotalSignUpDate]
      ,COUNT([City]) AS [TotalCity]
      ,COUNT([Country]) AS [TotalCountry]
  FROM [EcommerceDB].[dbo].[Customers]


-- Total number of unique products
SELECT COUNT(DISTINCT [ProductID]) AS [TotalProducts]
FROM [EcommerceDB].[dbo].[Products];


-- Count of non-NULL values in each column
SELECT COUNT([ProductID]) AS [TotalProductID],
       COUNT([ProductName]) AS [TotalProductName],
       COUNT([Category]) AS [TotalCategory],
       COUNT([Brand]) AS [TotalBrand],
       COUNT([UnitPrice]) AS [TotalUnitPrice]
FROM [EcommerceDB].[dbo].[Products];


-- Total number of unique orders
SELECT COUNT(DISTINCT [OrderID]) AS [TotalOrders]
FROM [EcommerceDB].[dbo].[Orders];


-- Count of non-NULL values in each column
SELECT COUNT([OrderID]) AS [TotalOrderID],
       COUNT([CustomerID]) AS [TotalCustomerID],
       COUNT([OrderDate]) AS [TotalOrderDate],
       COUNT([OrderStatus]) AS [TotalOrderStatus],
       COUNT([TotalAmount]) AS [TotalAmount]
FROM [EcommerceDB].[dbo].[Orders];


-- Total number of unique order items
SELECT COUNT(DISTINCT [OrderItemID]) AS [TotalOrderItems]
FROM [EcommerceDB].[dbo].[Order_Items];


-- Count of non-NULL values in each column
SELECT COUNT([OrderItemID]) AS [TotalOrderItemID],
       COUNT([OrderID]) AS [TotalOrderID],
       COUNT([ProductID]) AS [TotalProductID],
       COUNT([Quantity]) AS [TotalQuantity],
       COUNT([PricePerUnit]) AS [TotalPricePerUnit]
FROM [EcommerceDB].[dbo].[Order_Items];


-- Total number of unique inventory records
SELECT COUNT(DISTINCT [InventoryID]) AS [TotalInventory]
FROM [EcommerceDB].[dbo].[Inventory];


-- Count of non-NULL values in each column
SELECT COUNT([InventoryID]) AS [TotalInventoryID],
       COUNT([ProductID]) AS [TotalProductID],
       COUNT([Warehouse]) AS [TotalWarehouse],
       COUNT([StockQuantity]) AS [TotalStockQuantity]
FROM [EcommerceDB].[dbo].[Inventory];