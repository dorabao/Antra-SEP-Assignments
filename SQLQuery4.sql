USE NORTHWIND

--Q1
BEGIN TRANSACTION
SELECT* FROM dbo.Region WITH (UPDLOCK)
SELECT* FROM dbo.Territories WITH (UPDLOCK)
SELECT* FROM dbo.Employees WITH (UPDLOCK)
SELECT* FROM dbo.EmployeeTerritories WITH (UPDLOCK)

INSERT INTO dbo.Region VALUES(5, 'Middle Earth')
INSERT INTO dbo.Territories VALUES(54321, 'Gondor', 5)
INSERT INTO dbo.Employees (LastName, FirstName, Title) VALUES('King', 'Aragorn', 'King')

DECLARE @kingid INT
SET @kingid = (SELECT EmployeeID FROM dbo.Employees WHERE FirstName = 'Aragorn')
DECLARE @terr INT
SET @terr = (SELECT TerritoryID FROM dbo.Territories WHERE TerritoryDescription = 'Gondor')
INSERT INTO dbo.EmployeeTerritories VALUES(@kingid, @terr)

--Q2
UPDATE dbo.Territories
SET TerritoryDescription = 'Arnor'
WHERE TerritoryDescription = 'Gondor'

--Q3
ALTER TABLE dbo.Territories NOCHECK CONSTRAINT ALL
DELETE FROM dbo.Region
WHERE RegionID = 5
ALTER TABLE dbo.Territories CHECK CONSTRAINT ALL

ALTER TABLE dbo.Territories ADD FOREIGN KEY (RegionID) REFERENCES dbo.Region(RegionID)
COMMIT

--Q4 This query must be run in a seaprate batch
CREATE VIEW view_product_order_bao
AS 
SELECT p.ProductName, SUM(od.Quantity) AS Quantity
FROM dbo.Products p
JOIN dbo.[Order Details] od
ON p.ProductID = od.ProductID
GROUP BY p.ProductName

--Q5 This query must be run in a seaprate batch
CREATE PROC sp_product_order_quantity_bao
@productId INT,
@toalQuantity INT OUT
AS
BEGIN
SELECT SUM(od.Quantity) AS TotalQuantity FROM dbo.[Order Details] od WHERE od.ProductID = @productId
RETURN
END

--Q6
CREATE PROC sp_product_order_city_bao
@productName INT
AS
BEGIN
SELECT TOP 5 c.City, od.Quantity
FROM dbo.Products p
JOIN dbo.[Order Details] od
ON p.ProductID = od.ProductID  AND ProductName = @productName
JOIN dbo.Orders o
ON od.OrderID = o.OrderID
JOIN dbo.Customers c
ON o.CustomerID = c.CustomerID
ORDER BY od.Quantity DESC
END

--Q7
BEGIN TRANSACTION
SELECT* FROM dbo.Region WITH (UPDLOCK)
SELECT* FROM dbo.Territories WITH (UPDLOCK)
SELECT* FROM dbo.Employees WITH (UPDLOCK)
SELECT* FROM dbo.EmployeeTerritories WITH (UPDLOCK)

CREATE PROC sp_move_employee_bao
AS
BEGIN
IF EXISTS (
	SELECT e.EmployeeID
	FROM dbo.Employees e
	WHERE e.City = 'Troy'
)
	BEGIN
	INSERT INTO dbo.Region VALUES(6, 'North')
	INSERT INTO dbo.Territories VALUES(65432, 'Stevens Point', 6)
	UPDATE dbo.Employees SET City = 'Stevens Point' WHERE City = 'Troy'
	UPDATE dbo.EmployeeTerritories SET TerritoryID = 65432 WHERE EmployeeID IN (	
		SELECT e.EmployeeID
		FROM dbo.Employees e
		WHERE e.City = 'Stevens Point')
	END
END

--Q8
INSERT INTO dbo.Region VALUES(6, 'North')
INSERT INTO dbo.Territories VALUES(65432, 'Stevens Point', 6)
--open a new batch
CREATE TRIGGER trg_move_territory_bao
ON dbo.Employees
AFTER INSERT, UPDATE
AS
BEGIN
	DECLARE @numInSP INT
	SET @numInSP = (SELECT COUNT(EmployeeID) FROM Employees WHERE City = 'Stevens Point') 
	IF (@numInSP > 100)
	BEGIN
		UPDATE dbo.Employees SET City = 'Troy' WHERE City = 'Stevens Point'
		DECLARE @terrTroy INT
		SET @terrTroy = (SELECT TerritoryID FROM dbo.Territories WHERE TerritoryDescription = 'Troy')
		UPDATE dbo.EmployeeTerritories SET TerritoryID = @terrTroy WHERE EmployeeID IN (	
			SELECT e.EmployeeID
			FROM dbo.Employees e
			WHERE e.City = 'Troy')
	END
END

COMMIT

--Q9
CREATE TABLE people_bao (
Id INT PRIMARY KEY IDENTITY(1,1),
Name VARCHAR(100) NOT NULL,
City INT FOREIGN KEY REFERENCES city_bao(Id)
)

CREATE TABLE city_bao (
Id INT PRIMARY KEY IDENTITY(1,1),
City VARCHAR(50) UNIQUE
)

INSERT city_bao VALUES('Seattle')
INSERT city_bao VALUES('Green Bay')
INSERT people_bao VALUES('Aaron Rodgers', 2)
INSERT people_bao VALUES('Russell Wilson', 1)
INSERT people_bao VALUES('Jody Nelson', 2)

DECLARE @settleCode INT
SET @settleCode = (SELECT city_bao.Id FROM city_bao WHERE city_bao.City = 'Seattle')

ALTER TABLE people_bao NOCHECK CONSTRAINT ALL
DELETE FROM city_bao
WHERE city_bao.City = 'Seattle'
ALTER TABLE people_bao CHECK CONSTRAINT ALL

INSERT city_bao VALUES('Madison')
DECLARE @madisonCode INT
SET @madisonCode = (SELECT city_bao.Id FROM city_bao WHERE city_bao.City = 'Madison')
UPDATE people_bao
SET people_bao.City = @madisonCode
WHERE people_bao.City = @settleCode

--open a new batch
CREATE VIEW Packers_bao
AS 
SELECT p.Name
FROM people_bao p
JOIN city_bao c
ON p.City = c.Id AND c.City = 'Green Bay'

DROP TABLE people_bao
DROP TABLE city_bao

--Q10
CREATE PROC sp_birthday_employees_bao
AS
BEGIN
SELECT * INTO birthday_employees_bao FROM Employees WHERE MONTH(Employees.BirthDate) = 02 
END

--Q11
CREATE PROC sp_bao_1
AS
BEGIN
;WITH cte AS
(
	SELECT o.CustomerID, COUNT(od.ProductID) AS OrderSum
	FROM dbo.Orders o
	LEFT JOIN dbo.[Order Details] od
	ON o.OrderID = od.OrderID
	GROUP BY o.CustomerID
	HAVING COUNT(od.ProductID) <= 1
)
SELECT c.City, COUNT(c.CustomerID)
FROM dbo.Customers c
LEFT JOIN cte
ON c.CustomerID = cte.CustomerID
GROUP BY c.City
HAVING COUNT(c.CustomerID) >= 2
END

CREATE PROC sp_bao_2
AS
BEGIN
SELECT c.City, COUNT(c.CustomerID) AS CusNum
FROM dbo.Customers c
WHERE c.CustomerID NOT IN (
	SELECT o.CustomerID
	FROM dbo.Orders o
	LEFT JOIN dbo.[Order Details] od
	ON o.OrderID = od.OrderID
	GROUP BY o.CustomerID
	HAVING COUNT(OD.ProductID) > 1
)
GROUP BY c.City
HAVING COUNT(c.CustomerID) >= 2
END

--Q12
/*
SELECT * FROM TableA
UNION 
SELECT * FROM TableB
EXCEPT
(
	SELECT * FROM TableA
	INTERSECT
	SELECT * FROM TableB 
)
*/

--Q14
/*
SELECT t.[Firs tName] ||' '|| t.[Last Name] ||' '|| ISNULL(t.[Middle Name] || '.' , '') AS [Full Name] 
FROM table t
*/

--Q15
/*
SELECT TOP 1 t.Student
FROM table t
WHERE t.Sex = 'F'
ORDER BY t.Marks DESC
*/

--Q16
/*
SELECT *
FROM table t
WHERE t.Sex = 'F'
ORDER BY t.Sex ASC, t.Marks DESC
*/