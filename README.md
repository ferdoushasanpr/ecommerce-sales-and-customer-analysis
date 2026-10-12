# 🛒 E-Commerce Sales \& Customer Analytics — SQL Server

## 📌 Project Overview
This project is an **E-Commerce Sales \& Customer Analytics database project built with Microsoft SQL Server**. The goal of the project is to analyze the e-commerce dataset to gain actionable insights into:

- Customer behavior
- Sales and revenue
- Orders and order trends
- Products and categories
- Brand performance
- Customer segmentation
- Geographic sales performance
- Product combinations
- Inventory levels
- Warehouse inventory
- Customer retention and repeat purchasing

---

## 🎯 Project Objectives

The main objectives of this project are to:

1. Understand the structure and quality of the e-commerce database.
2. Analyze customers, products, orders, and inventory.
3. Calculate important sales KPIs.
4. Identify top-performing products, brands, categories, and customers.
5. Analyze monthly and yearly revenue trends.
6. Measure month-over-month revenue growth.
7. Identify repeat and inactive customers.
8. Segment customers based on their spending.
9. Analyze product purchasing patterns.
10. Evaluate inventory distribution and stock risk.
11. Create reusable SQL objects such as a **View** and **Stored Procedure**.

---

# 🗂️ Database Schema

The database is named:

```
EcommerceDB
```

It contains five main tables:

```
EcommerceDB
├── Customers
├── Products
├── Orders
├── Order_Items
└── Inventory

```

### Entity Relationship Overview

```
Customers
│
│ CustomerID
▼
Orders
│
│ OrderID
▼
Order_Items
│
│ ProductID
▼
Products


Products
│
│ ProductID
▼

```

---

# 📊 Tables

## 1. Customers

Stores customer information.
| Column | Data Type | Description |
| --- | --- | --- |
| CustomerID | NVARCHAR(50) | Unique customer identifier |
| FullName | NVARCHAR(50) | Customer name |
| Email | NVARCHAR(50) | Customer email |
| SignUpDate | DATE | Customer registration date |
| City | NVARCHAR(50) | Customer city |
| Country | NVARCHAR(50) | Customer country |

---

## 2. Products

Contains information about products sold by the e-commerce business.

| Column | Data Type | Description |
| --- | --- | --- |
| ProductID | NVARCHAR(50) | Unique product identifier |
| ProductName | NVARCHAR(50) | Product name |
| Category | NVARCHAR(50) | Product category |
| Brand | NVARCHAR(50) | Product brand |
| UnitPrice | FLOAT | Product unit price |

---



## 3. Orders

Stores customer order information.

| Column | Data Type | Description |
| --- | --- | --- |
| OrderID | NVARCHAR(50) | Unique order identifier |
| CustomerID | NVARCHAR(50) | Customer who placed the order |
| OrderDate | DATE | Date of the order |
| OrderStatus | NVARCHAR(50) | Current order status |
| TotalAmount | FLOAT | Total order amount |

---

## 4. Order_Items

Contains individual products included in each order.

| Column | Data Type | Description |
| --- | --- | --- |
| OrderItemID | NVARCHAR(50) | Unique order-item identifier |
| OrderID | NVARCHAR(50) | Related order |
| ProductID | NVARCHAR(50) | Related product |
| Quantity | TINYINT | Quantity purchased |
| PricePerUnit | FLOAT | Price per unit at the time of purchase |

---

## 5. Inventory

Stores product stock information across warehouses.

| Column | Data Type | Description |
| --- | --- | --- |
| InventoryID | NVARCHAR(50) | Unique inventory record |
| ProductID | NVARCHAR(50) | Related product |
| Warehouse | NVARCHAR(50) | Warehouse location |
| StockQuantity | SMALLINT | Available stock |

---

# 🔍 Data Quality Checks

Before performing the analysis, some SQL queries are used to examine the database and check the completeness of the imported data.

Examples include:

- Counting unique customers
- Counting unique products
- Counting unique orders
- Counting unique order items
- Counting unique inventory records
- Checking non-NULL values across columns


Example:

```

SELECT COUNT(DISTINCT CustomerID) AS TotalCustomers

FROM EcommerceDB.dbo.Customers;

```

Column completeness was also checked using `COUNT()`:

```

SELECT

  COUNT(CustomerID) AS TotalCustomerID,
  COUNT(FullName) AS TotalFullName,
  COUNT(Email) AS TotalEmail,
  COUNT(SignUpDate) AS TotalSignUpDate,
  COUNT(City) AS TotalCity,
  COUNT(Country) AS TotalCountry

FROM EcommerceDB.dbo.Customers;

```

---
