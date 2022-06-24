-- 06/22/2022 Day 2 SQL

USE AdventureWorks2019
GO

-- 1.Write a query that lists the country and province names from person.CountryRegion and person.StateProvince tables. Join them and produce a result set similar to the following.
--  Country                        Province
SELECT cr.Name AS Country, sp.Name AS Province
FROM person.CountryRegion cr JOIN person.StateProvince sp on cr.CountryRegionCode = sp.CountryRegionCode
ORDER BY Country

-- 2. Write a query that lists the country and province names from person.CountryRegion and 
-- person.StateProvince tables and list the countries filter them by Germany and Canada. Join them and produce a result set similar to the following.
--  Country                        Province
SELECT cr.Name AS Country, sp.Name AS Province
FROM person.CountryRegion cr JOIN person.StateProvince sp on cr.CountryRegionCode = sp.CountryRegionCode
WHERE cr.Name IN ('Germany', 'Canada')
ORDER BY Country

-- 3. List all Products that has been sold at least once in last 25 years.
USE Northwind
GO

declare @today datetime
select @today = GETDATE()

SELECT o.OrderID, od.ProductID, o.OrderDate
FROM Orders o JOIN [Order Details] od ON o.OrderID = od.OrderID
WHERE DATEDIFF(day, OrderDate, @today) > 25*365

-- 4. List top 5 locations (Zip Code) where the products sold most in last 25 years.
declare @today datetime
select @today = GETDATE()

SELECT TOP 5 o.ShipPostalCode, COUNT(o.ShipPostalCode) AS NumOfProducts
FROM Orders o JOIN [Order Details] od ON o.OrderID = od.OrderID
WHERE DATEDIFF(day, OrderDate, @today) > 25*365 AND o.ShipPostalCode IS NOT NULL
GROUP BY o.ShipPostalCode
ORDER BY NumOfProducts DESC

-- 5. List all city names and number of customers in that city.  
SELECT c.City, COUNT(c.City) AS NumOfCustomers
FROM Customers c JOIN Orders o ON c.CustomerID = o.CustomerID
GROUP BY c.City

-- 6. List city names which have more than 2 customers, and number of customers in that city
SELECT c.City, COUNT(c.City) AS NumOfCustomers
FROM Customers c JOIN Orders o ON c.CustomerID = o.CustomerID
GROUP BY c.City
HAVING COUNT(c.city) > 2
ORDER BY NumOfCustomers DESC

-- 7. Display the names of all customers along with the count of products they bought
SELECT c.ContactName, COUNT(od.Quantity) AS NumOfProducts 
FROM [Order Details] od JOIN Orders o ON od.OrderID = o.OrderID RIGHT JOIN Customers c ON c.CustomerID = o.CustomerID
GROUP BY c.ContactName
ORDER BY c.ContactName

-- 8. Display the customer ids who bought more than 100 Products with count of products.
SELECT c.CustomerID, COUNT(od.Quantity) AS NumOfProducts 
FROM [Order Details] od JOIN Orders o ON od.OrderID = o.OrderID RIGHT JOIN Customers c ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerID
HAVING COUNT(od.Quantity) > 100

-- 9. List all of the possible ways that suppliers can ship their products. Display the results as below
--  Supplier Company Name                        Shipping Company Name
--  ---------------------------------            ----------------------------------
SELECT DISTINCT s.CompanyName AS [Supplier Company Name], sh.CompanyName AS [Shipping Company Name]
FROM Shippers sh JOIN Orders o ON sh.ShipperID = o.ShipVia JOIN [Order Details] od ON od.OrderID = o.OrderID JOIN Products p ON od.ProductID = p.ProductID JOIN Suppliers s ON s.SupplierID = p.ProductID

-- 10. Display the products order each day. Show Order date and Product Name.
SELECT o.OrderDate, p.ProductName
FROM Orders o JOIN [Order Details] od ON o.OrderID = od.OrderID JOIN Products p ON od.ProductID = p.ProductID
ORDER BY OrderDate

-- 11. Displays pairs of employees who have the same job title.
SELECT e1.FirstName + ' ' +  e1.LastName AS Name1, e2.FirstName + ' ' + e2.LastName AS Name2
FROM Employees e1 JOIN Employees e2 ON e1.Title = e2.Title
WHERE e1.FirstName + ' ' +  e1.LastName != e2.FirstName + ' ' + e2.LastName
ORDER BY Name1

-- 12. Display all the Managers who have more than 2 employees reporting to them.
SELECT m.FirstName + ' ' + m.LastName AS Manager, COUNT(m.FirstName + ' ' + m.LastName) AS NumOfEmployees
FROM Employees e JOIN Employees m ON e.ReportsTo = m.EmployeeID
GROUP BY m.FirstName + ' ' + m.LastName
HAVING COUNT(m.FirstName + ' ' + m.LastName) > 2

-- 13. Display the customers and suppliers by city. The results should have the following columns
-- City
-- Name
-- Contact Name,
-- Type(Customer or Supplier)
SELECT City, CompanyName AS Name, ContactName, 'Customer' AS Type
FROM Customers
UNION ALL
SELECT City, CompanyName AS Name, ContactName, 'Supplier' AS Type
FROM Suppliers
ORDER BY City

-- 14. List all cities that have both Employees and Customers.
SELECT DISTINCT c.City
FROM Customers c JOIN Employees e ON c.City = e.City

-- 15. List all cities that have Customers but no Employee.
-- a. Use sub-queryy
SELECT DISTINCT City
FROM Customers
WHERE City NOT IN (
SELECT City
FROM Employees
)

-- b. Do not use sub-query
SELECT DISTINCT c.City
FROM Customers c LEFT JOIN Employees e ON c.City = e.City
WHERE e.city IS NULL

-- 16. List all products and their total order quantities throughout all orders.
SELECT p.ProductID, SUM(od.Quantity) AS TotalNumOrder
FROM Orders o JOIN [Order Details] od ON o.OrderID = od.OrderID JOIN Products p ON p.ProductID = od.ProductID
GROUP BY p.ProductID
ORDER BY p.ProductID

-- 17. List all Customer Cities that have at least two customers.
-- a. Use union
SELECT dt.City, COUNT(dt.CustomerID) AS NumOfCustomers
FROM
(SELECT CustomerID, City
FROM Customers
UNION
SELECT CustomerID, ShipCity
FROM Orders) dt
GROUP BY dt.City
HAVING COUNT(dt.CustomerID) >= 2
ORDER BY NumOfCustomers DESC

-- b. Use no union
SELECT dt.City, COUNT(dt.CustomerID) AS NumOfCustomers
FROM
(SELECT DISTINCT c.CustomerID, c.City
FROM Customers c JOIN Orders o ON c.CustomerID = o.CustomerID) dt
GROUP BY dt.City
HAVING COUNT(dt.CustomerID) >= 2
ORDER BY NumOfCustomers DESC

-- 18. List all Customer Cities that have ordered at least two different kinds of products.
SELECT c.CustomerID, COUNT(od.ProductID) AS NumOfProducts
FROM Customers c JOIN Orders o ON c.CustomerID = o.CustomerID JOIN [Order Details] od on od.OrderID = o.OrderID
GROUP BY c.CustomerID
HAVING COUNT(od.ProductID) >= 2
ORDER BY NumOfProducts DESC

-- 19. List 5 most popular products, their average price, and the customer city that ordered most quantity of it.
SELECT dt.ProductID, dt.UnitPrice, dt.City, dt.Quantity
FROM(
SELECT c.City, od.Quantity, od.UnitPrice, RANK() OVER (ORDER BY Quantity DESC) RNK, od.ProductID
FROM [Order Details] od JOIN Orders o ON od.OrderID = o.OrderID JOIN Customers c ON c.CustomerID = o.CustomerID) dt
WHERE RNK < 5

-- 20. List one city, if exists, that is the city from where the employee sold most orders (not the product quantity) is, and also the city of most total quantity of products ordered from. (tip: join sub-query)
SELECT citye.City
FROM (
SELECT TOP 1 e.City, COUNT(o.OrderID) AS NumOfOrders
FROM Employees e JOIN Orders o ON e.EmployeeID = o.EmployeeID
GROUP BY e.City
ORDER BY NumOfOrders DESC) AS CityE
JOIN
(SELECT TOP 1 o.ShipCity, SUM(od.Quantity) AS TotalNumProducts
FROM Orders o JOIN [Order Details] od ON o.OrderID = od.OrderID
GROUP BY o.ShipCity
ORDER BY TotalNumProducts DESC) AS CityP
ON CityE.City = CityP.ShipCity

-- 21. How do you remove the duplicates record of a table?
-- Using GROUP BY to combine the duplicates record.
