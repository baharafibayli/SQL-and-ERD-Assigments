

CREATE DATABASE IF NOT EXISTS SalesDB;

USE SalesDB;

CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Country VARCHAR(50),
    Score INT
);


CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    Product VARCHAR(100),
    Category VARCHAR(50),
    Price DECIMAL(10,2)
);


CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Department VARCHAR(50),
    BirthDate DATE,
    Gender VARCHAR(10),
    Salary DECIMAL(10,2),
    ManagerID INT,
    FOREIGN KEY (ManagerID) REFERENCES Employees(EmployeeID)
);


CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    ProductID INT,
    CustomerID INT,
    SalesPersonID INT,
    OrderDate DATE,
    ShipDate DATE,
    OrderStatus VARCHAR(30),
    ShipAddress VARCHAR(150),
    BillAddress VARCHAR(150),
    Quantity INT,
    Sales DECIMAL(10,2),
    CreationTime DATETIME,
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    FOREIGN KEY (SalesPersonID) REFERENCES Employees(EmployeeID)
);


INSERT INTO Customers (CustomerID, FirstName, LastName, Country, Score)
VALUES
(1, 'Ayla', 'Karimova', 'Azerbaijan', 720),
(2, 'John', 'Miller', 'USA', 450),
(3, 'Emma', 'Schmidt', 'Germany', 860),
(4, 'Sara', 'Martin', 'France', 280),
(5, 'Lukas', 'Weber', 'Germany', 550);



INSERT INTO Products (ProductID, Product, Category, Price)
VALUES
(101, 'Wireless Mouse', 'Electronics', 55.00),
(102, 'Office Chair', 'Furniture', 230.00),
(103, 'Laptop', 'Electronics', 850.00),
(104, 'Notebook', 'Stationery', 12.00),
(105, 'Smart Phone', 'Electronics', 420.00);



INSERT INTO Employees
(EmployeeID, FirstName, LastName, Department, BirthDate, Gender, Salary, ManagerID)
VALUES
(11, 'David', 'Lee', 'Sales', '1990-05-12', 'Male', 2200.00, NULL),
(12, 'Maya', 'Brown', 'Sales', '1992-08-20', 'Female', 2400.00, NULL),
(13, 'Alex', 'Green', 'Support', '1995-03-15', 'Male', 1900.00, NULL);



INSERT INTO Orders
(OrderID, ProductID, CustomerID, SalesPersonID, OrderDate, ShipDate,
OrderStatus, ShipAddress, BillAddress, Quantity, Sales, CreationTime)
VALUES
(201, 101, 1, 11, '2026-10-04', '2026-10-06', 'Delivered',
'Baku, Azerbaijan', 'Baku, Azerbaijan', 2, 110.00, '2026-10-04 09:00:00'),

(202, 103, 3, 12, '2026-10-08', '2026-10-10', 'Shipped',
'Berlin, Germany', 'Berlin, Germany', 1, 850.00, '2026-10-08 10:30:00'),

(203, 102, 2, 11, '2026-10-12', NULL, 'Pending',
'New York, USA', 'New York, USA', 1, 230.00, '2026-10-12 11:00:00'),

(204, 105, 5, 12, '2026-10-15', '2026-10-17', 'Delivered',
'Berlin, Germany', 'Berlin, Germany', 1, 420.00, '2026-10-15 14:00:00');




SELECT * FROM Customers;

SELECT FirstName, LastName, Country
FROM Customers;



SELECT CustomerID, FirstName, LastName, Country
FROM Customers
WHERE Country = 'Germany';


 

SELECT FirstName, LastName, Country, Score
FROM Customers
WHERE Score >= 300
AND Country IN ('Germany', 'France');




SELECT ProductID, Product, Category, Price
FROM Products
ORDER BY Price DESC;




SELECT Product, Price
FROM Products
WHERE Price BETWEEN 50 AND 300;




SELECT Product, Category
FROM Products
WHERE Product LIKE '%Phone%';




SELECT DISTINCT Category
FROM Products
ORDER BY Category ASC;




SELECT
    Orders.OrderID,
    Customers.FirstName,
    Customers.LastName
FROM Orders
INNER JOIN Customers
ON Orders.CustomerID = Customers.CustomerID;



SELECT
    OrderStatus,
    COUNT(OrderID) AS TotalOrders,
    SUM(Sales) AS TotalSales
FROM Orders
GROUP BY OrderStatus
ORDER BY TotalSales DESC;




INSERT INTO Products (ProductID, Product, Category, Price)
VALUES (106, 'Keyboard', 'Electronics', 75);

UPDATE Products
SET Price = 90
WHERE ProductID = 106;

SELECT * FROM Products
WHERE ProductID = 106;

DELETE FROM Products
WHERE ProductID = 106;


SELECT FirstName, LastName, Country, Score
FROM Customers
WHERE Score > 500
ORDER BY Score DESC;


SELECT FirstName, LastName, Country, Score
FROM Customers
WHERE Country IN ('Germany', 'France', 'USA')
AND Score >= 300;


SELECT 
    Customers.FirstName,
    Customers.LastName,
    Orders.OrderID,
    Orders.OrderDate,
    Orders.Sales
FROM Customers
INNER JOIN Orders
ON Customers.CustomerID = Orders.CustomerID;


SELECT
    Customers.CustomerID,
    Customers.FirstName,
    Customers.LastName,
    Customers.Country
FROM Customers
LEFT JOIN Orders
ON Customers.CustomerID = Orders.CustomerID
WHERE Orders.OrderID IS NULL;
-- Task 5: Total customer spending

SELECT
    Customers.FirstName,
    Customers.LastName,
    SUM(Orders.Sales) AS TotalSales
FROM Customers
INNER JOIN Orders
ON Customers.CustomerID = Orders.CustomerID
GROUP BY Customers.CustomerID, Customers.FirstName, Customers.LastName
ORDER BY TotalSales DESC;
-- Task 6: Loyalty threshold

SELECT
    Customers.FirstName,
    Customers.LastName,
    SUM(Orders.Sales) AS TotalSales
FROM Customers
INNER JOIN Orders
ON Customers.CustomerID = Orders.CustomerID
GROUP BY Customers.CustomerID, Customers.FirstName, Customers.LastName
HAVING SUM(Orders.Sales) > 1000;
-- Task 7: Top-five report

SELECT
    CONCAT(Customers.FirstName, ' ', Customers.LastName) AS Customer,
    Customers.Country,
    SUM(Orders.Sales) AS TotalSales
FROM Customers
INNER JOIN Orders
ON Customers.CustomerID = Orders.CustomerID
GROUP BY Customers.CustomerID, Customers.FirstName,
         Customers.LastName, Customers.Country
ORDER BY TotalSales DESC
LIMIT 5;
-- =========================================
-- ASSIGNMENT 2: ORDER AND DELIVERY INVESTIGATION
-- =========================================

-- Task 1: October orders

SELECT
    OrderID,
    CustomerID,
    OrderDate,
    ShipDate,
    OrderStatus
FROM Orders
WHERE OrderDate BETWEEN '2026-10-01' AND '2026-10-31';
-- Task 2: Pending queue

SELECT *
FROM Orders
WHERE OrderStatus = 'Pending'
ORDER BY OrderDate ASC;
-- Task 3: Late shipments

SELECT
    Orders.OrderID,
    CONCAT(Customers.FirstName, ' ', Customers.LastName) AS Customer,
    Orders.OrderDate,
    Orders.ShipDate
FROM Orders
INNER JOIN Customers
ON Orders.CustomerID = Customers.CustomerID
WHERE DATEDIFF(Orders.ShipDate, Orders.OrderDate) > 7;
-- Task 4: Affected customers

SELECT DISTINCT
    Customers.FirstName,
    Customers.LastName,
    Customers.Country
FROM Customers
INNER JOIN Orders
ON Customers.CustomerID = Orders.CustomerID
WHERE DATEDIFF(Orders.ShipDate, Orders.OrderDate) > 7;
-- Task 5: Status correction

SELECT *
FROM Orders
WHERE OrderID = 105;
UPDATE Orders
SET OrderStatus = 'Shipped',
    ShipDate = '2026-11-05'
WHERE OrderID = 105;
-- Task 6: Address correction

SELECT *
FROM Orders
WHERE OrderID = 110;
UPDATE Orders
SET ShipAddress = '45 Main Street, Baku'
WHERE OrderID = 110;
-- Task 7: Remove test data

SELECT *
FROM Orders
WHERE OrderID = 999;
DELETE FROM Orders
WHERE OrderID = 999;
-- Task 8: Status distribution

SELECT
    OrderStatus,
    COUNT(*) AS OrderCount
FROM Orders
GROUP BY OrderStatus;
-- Task 9: Unshipped orders

SELECT
    CONCAT(Customers.FirstName, ' ', Customers.LastName) AS Customer,
    Orders.OrderDate,
    Orders.OrderStatus
FROM Orders
INNER JOIN Customers
ON Orders.CustomerID = Customers.CustomerID
WHERE Orders.ShipDate IS NULL;
-- =========================================
-- ASSIGNMENT 3: PRODUCTS AND EMPLOYEE PERFORMANCE
-- =========================================

-- Task 1: Affordable products

SELECT
    Product,
    Category,
    Price
FROM Products
WHERE Price BETWEEN 50 AND 300
ORDER BY Price ASC;
-- Task 2: Premium electronics

SELECT
    Product,
    Category,
    Price
FROM Products
WHERE Category = 'Electronics'
AND Price > 500;
-- Task 3: Product sales

SELECT
    Products.Product,
    Products.Category,
    Orders.Quantity,
    Orders.Sales
FROM Products
INNER JOIN Orders
ON Products.ProductID = Orders.ProductID;
-- Task 4: Best-selling products

SELECT
    Products.Product,
    SUM(Orders.Quantity) AS TotalQuantity
FROM Products
INNER JOIN Orders
ON Products.ProductID = Orders.ProductID
GROUP BY Products.ProductID, Products.Product
ORDER BY TotalQuantity DESC
LIMIT 5;
-- Task 5: Unsold items

SELECT
    Products.ProductID,
    Products.Product,
    Products.Category,
    Products.Price
FROM Products
LEFT JOIN Orders
ON Products.ProductID = Orders.ProductID
WHERE Orders.OrderID IS NULL;
-- Task 6: Employee performance

SELECT
    Employees.FirstName,
    Employees.LastName,
    Employees.Department,
    SUM(Orders.Sales) AS TotalSales
FROM Employees
INNER JOIN Orders
ON Employees.EmployeeID = Orders.SalesPersonID
GROUP BY
    Employees.EmployeeID,
    Employees.FirstName,
    Employees.LastName,
    Employees.Department;
-- Task 7: Top-performing staff

SELECT
    Employees.FirstName,
    Employees.LastName,
    Employees.Department,
    SUM(Orders.Sales) AS TotalSales
FROM Employees
INNER JOIN Orders
ON Employees.EmployeeID = Orders.SalesPersonID
GROUP BY
    Employees.EmployeeID,
    Employees.FirstName,
    Employees.LastName,
    Employees.Department
HAVING SUM(Orders.Sales) > 5000
ORDER BY TotalSales DESC;
-- Task 8: New product

INSERT INTO Products (ProductID, Product, Category, Price)
VALUES (501, 'Wireless Keyboard', 'Electronics', 75);
-- Task 9: Price correction

UPDATE Products
SET Price = 90
WHERE ProductID = 501;
-- Task 10: Inventory column

ALTER TABLE Products
ADD StockQuantity INT;
-- Task 11: Combined directory

SELECT FirstName, LastName
FROM Customers

UNION

SELECT FirstName, LastName
FROM Employees;
-- Task 12: Category performance

SELECT
    Products.Category,
    SUM(Orders.Quantity) AS TotalQuantity,
    SUM(Orders.Sales) AS TotalSales
FROM Products
INNER JOIN Orders
ON Products.ProductID = Orders.ProductID
GROUP BY Products.Category
HAVING SUM(Orders.Sales) > 2000
ORDER BY TotalSales DESC;