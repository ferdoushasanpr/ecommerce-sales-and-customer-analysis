USE [EcommerceDB]
GO

/****** Object:  StoredProcedure [dbo].[SearchOrderDetails]    Script Date: 9/29/2026 1:12:04 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SearchOrderDetails]
@OrderID NVARCHAR (50)=NULL, @OrderDate DATE=NULL, @CustomerID NVARCHAR (50)=NULL, @FullName NVARCHAR (200)=NULL, @City NVARCHAR (100)=NULL, @Country NVARCHAR (100)=NULL, @OrderStatus NVARCHAR (50)=NULL, @OrderItemID NVARCHAR (50)=NULL, @ProductID NVARCHAR (50)=NULL, @ProductName NVARCHAR (200)=NULL, @Category NVARCHAR (100)=NULL, @Brand NVARCHAR (100)=NULL, @Quantity INT=NULL, @PricePerUnit DECIMAL (18, 2)=NULL
AS
BEGIN
    SELECT [o].[OrderID],
           [o].[OrderDate],
           [o].[CustomerID],
           [c].[FullName],
           [c].[City],
           [c].[Country],
           [o].[OrderStatus],
           [oi].[OrderItemID],
           [oi].[ProductID],
           [p].[ProductName],
           [p].[Category],
           [p].[Brand],
           [oi].[Quantity],
           [oi].[PricePerUnit],
           [oi].[Quantity] * [oi].[PricePerUnit] AS [LineTotal]
    FROM   [dbo].[Orders] AS [o]
           INNER JOIN
           [dbo].[Customers] AS [c]
           ON [o].[CustomerID] = [c].[CustomerID]
           INNER JOIN
           [dbo].[Order_Items] AS [oi]
           ON [o].[OrderID] = [oi].[OrderID]
           INNER JOIN
           [dbo].[Products] AS [p]
           ON [oi].[ProductID] = [p].[ProductID]
    WHERE  (@OrderID IS NULL
            OR [o].[OrderID] LIKE N'%' + @OrderID + N'%')
           AND (@OrderDate IS NULL
                OR [o].[OrderDate] = @OrderDate)
           AND (@CustomerID IS NULL
                OR [o].[CustomerID] LIKE N'%' + @CustomerID + N'%')
           AND (@FullName IS NULL
                OR [c].[FullName] LIKE N'%' + @FullName + N'%')
           AND (@City IS NULL
                OR [c].[City] LIKE N'%' + @City + N'%')
           AND (@Country IS NULL
                OR [c].[Country] LIKE N'%' + @Country + N'%')
           AND (@OrderStatus IS NULL
                OR [o].[OrderStatus] LIKE N'%' + @OrderStatus + N'%')
           AND (@OrderItemID IS NULL
                OR [oi].[OrderItemID] LIKE N'%' + @OrderItemID + N'%')
           AND (@ProductID IS NULL
                OR [oi].[ProductID] LIKE N'%' + @ProductID + N'%')
           AND (@ProductName IS NULL
                OR [p].[ProductName] LIKE N'%' + @ProductName + N'%')
           AND (@Category IS NULL
                OR [p].[Category] LIKE N'%' + @Category + N'%')
           AND (@Brand IS NULL
                OR [p].[Brand] LIKE N'%' + @Brand + N'%')
           AND (@Quantity IS NULL
                OR [oi].[Quantity] = @Quantity)
           AND (@PricePerUnit IS NULL
                OR [oi].[PricePerUnit] = @PricePerUnit);
END
GO


