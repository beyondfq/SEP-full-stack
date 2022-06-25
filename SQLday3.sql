-- 06/23/2022 Day 3 SQL

-- Use Northwind database.
-- All questions are based on assumptions described by the Database Diagram sent to you yesterday. 
-- When inserting, make up info if necessary. Write query for each step. Do not use IDE. BE CAREFUL WHEN DELETING DATA OR DROPPING TABLE.

USE Northwind
GO

-- 1. Create a view named “view_product_order_[your_last_name]”, list all products and total ordered quantity for that product.
CREATE VIEW view_product_order_Feng
AS
(
SELECT p.ProductID, SUM(od.Quantity) AS OrderedQuantity
FROM Products p JOIN [Order Details] od ON p.ProductID = od.ProductID
GROUP BY p.ProductID
)

SELECT *
FROM view_product_order_Feng
ORDER BY ProductID

-- 2. Create a stored procedure “sp_product_order_quantity_[your_last_name]” that accept product id as an input and total quantities of order as output parameter.
CREATE PROC sp_product_order_quantity_Feng
@id int,
@quantity int out
AS
BEGIN
SELECT @quantity = dt.OrderedQuantity
FROM(
SELECT p.ProductID, SUM(od.Quantity) AS OrderedQuantity
FROM Products p JOIN [Order Details] od ON p.ProductID = od.ProductID
GROUP BY p.ProductID) dt
WHERE dt.ProductID = @id
END

BEGIN
DECLARE @quan int
exec sp_product_order_quantity_Feng 2, @quan out
print @quan
END

-- 3. Create a stored procedure “sp_product_order_city_[your_last_name]” that accept product name as an input and top 5 cities that ordered most that product 
-- combined with the total quantity of that product ordered from that city as output.
CREATE PROC sp_product_order_city_Feng
@Pname varchar(20),
@City varchar(20) out,
@Quan int out
AS
BEGIN
SELECT TOP 5 @City = dt.ShipCity, @Quan = dt.Quantity
FROM(
SELECT p.ProductName, SUM(od.Quantity) AS Quantity, o.ShipCity
FROM Orders o JOIN [Order Details] od ON o.OrderID = od.OrderID JOIN Products p ON p.ProductID = od.ProductID
GROUP BY p.ProductName, o.ShipCity) dt
WHERE dt.ProductName = @Pname
ORDER BY dt.Quantity DESC
END

BEGIN
DECLARE @pCity varchar(20)
DECLARE @pQuan int
exec sp_product_order_city_Feng 'Chai', @pCity out
print @pCity
END

-- 4. Create 2 new tables “people_your_last_name” “city_your_last_name”. City table has two records: {Id:1, City: Seattle}, {Id:2, City: Green Bay}. 
-- People has three records: {id:1, Name: Aaron Rodgers, City: 2}, {id:2, Name: Russell Wilson, City:1}, {Id: 3, Name: Jody Nelson, City:2}. Remove city of Seattle. 
-- If there was anyone from Seattle, put them into a new city “Madison”. Create a view “Packers_your_name” lists all people from Green Bay. 
-- If any error occurred, no changes should be made to DB. (after test) Drop both tables and view.
CREATE TABLE people_feng
(
Id int primary key,
Name varchar(20) NOT NULL,
City int FOREIGN KEY REFERENCES city_feng(Id) on delete set NULL
)

INSERT INTO people_feng VALUES (1, 'Aaron Rodgers', 2)
INSERT INTO people_feng VALUES (2, 'Russell Wilson', 1)

CREATE TABLE city_feng
(
Id int primary key,
City varchar(20) NOT NULL
)

INSERT INTO city_feng VALUES (1, 'Seattle')
INSERT INTO city_feng VALUES (2, 'Green Bay')
INSERT INTO city_feng VALUES (3, 'Madison')

SELECT * FROM people_feng
SELECT * FROM city_feng

DROP TABLE people_feng
DROP TABLE city_feng

UPDATE people_feng
SET City = 3
Where City = 1

DELETE FROM city_feng
WHERE City = 'Seattle'

CREATE VIEW Packers_Feng
AS
(
SELECT Name 
FROM people_feng pf JOIN city_feng cf ON pf.City = cf.Id
WHERE cf.City = 'Green Bay'
)

SELECT *
FROM Packers_Feng

-- 5. Create a stored procedure “sp_birthday_employees_[you_last_name]” that creates a new table “birthday_employees_your_last_name” and fill it with all employees that have a birthday on Feb. 
-- (Make a screen shot) drop the table. Employee table should not be affected.
CREATE PROC sp_birthday_employees_feng
@name varchar(20),
@birth varchar(20)
AS
BEGIN
CREATE TABLE birthday_employees_feng(
Name varchar(20) NOT NULL,
BirthDate datetime
)

SELECT FirstName + ' ' + LastName AS Name, BirthDate
FROM Employees
WHERE MONTH(BirthDate) = 2

INSERT INTO birthday_employees_feng VALUES ('Andrew Fuller', '1952-02-19 00:00:00.000')
END

SELECT *
FROM birthday_employees_feng
SELECT FirstName + ' ' + LastName AS Name, BirthDate
FROM Employees

DROP TABLE birthday_employees_feng

-- 6. How do you make sure two tables have the same data?
-- Check the number of records of table1 and table2. If they have the same number of rows, then
SELECT * FROM table1
UNION
SELECT * FROM table2
-- Check the number of records for the new table, if it has the same number as the number of table1.
-- The two tables have the same data.