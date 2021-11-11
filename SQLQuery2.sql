USE AdventureWorks2019

SELECT COUNT(ProductID)
FROM Production.Product

SELECT COUNT(Production.Product.ProductID)
FROM Production.Product, Production.ProductSubcategory
WHERE Production.Product.ProductSubcategoryID = Production.ProductSubcategory.ProductSubcategoryID

SELECT ProductSubcategoryID, COUNT(ProductID) "CountedProducts" 
FROM Production.Product
GROUP BY ProductSubcategoryID

SELECT ProductSubcategoryID, COUNT(ProductID) "CountedProducts" 
FROM Production.Product
GROUP BY ProductSubcategoryID
HAVING ProductSubcategoryID IS NULL

SELECT SUM(Quantity)
FROM Production.ProductInventory

SELECT ProductID, SUM(Quantity) "TheSum"
FROM Production.ProductInventory
WHERE LocationID = 40
GROUP BY ProductID
HAVING SUM(Quantity) <100

SELECT Shelf, ProductID, SUM(Quantity) "TheSum"
FROM Production.ProductInventory
WHERE LocationID = 40
GROUP BY Shelf, ProductID
HAVING SUM(Quantity) <100

SELECT AVG(Quantity)
FROM Production.ProductInventory
WHERE LocationID = 10

SELECT ProductID, Shelf, AVG(Quantity) "TheAvg"
FROM Production.ProductInventory
GROUP BY ProductID, Shelf

SELECT ProductID, Shelf, AVG(Quantity) "TheAvg"
FROM Production.ProductInventory
GROUP BY ProductID, Shelf
HAVING Shelf <> 'N/A'

SELECT Color, Class, COUNT(*) "TheCount", AVG(ListPrice) "AvgPrice"
FROM Production.Product
WHERE Color IS NOT NULL AND Class IS NOT NULL
GROUP BY Color, Class

SELECT cr.Name "Coutry", sp.Name "Province"
FROM Person.CountryRegion cr
JOIN Person.StateProvince sp
ON cr.CountryRegionCode = sp.CountryRegionCode

SELECT cr.Name "Coutry", sp.Name "Province"
FROM Person.CountryRegion cr
JOIN Person.StateProvince sp
ON cr.CountryRegionCode = sp.CountryRegionCode
WHERE cr.Name IN ('Germany', 'Canada')

USE NorthWind

SELECT p.ProductName "ProductsSoldIn25Y"
FROM dbo.Products p
JOIN dbo.[Order Details] od
ON p.ProductID = od.ProductID
JOIN dbo.Orders o
ON od.OrderID = o.OrderID
WHERE DATEDIFF(YEAR, CURRENT_TIMESTAMP, o.OrderDate) < 25
GROUP BY p.ProductName

SELECT TOP 5 o.ShipPostalCode "Location", SUM(od.Quantity) "ProductSold"
FROM dbo.Orders o
JOIN dbo.[Order Details] od
ON o.OrderID = od.OrderID AND o.ShipPostalCode IS NOT NULL
GROUP BY o.ShipPostalCode

SELECT TOP 5 o.ShipPostalCode "Location", SUM(od.Quantity) "ProductSold"
FROM dbo.Orders o
JOIN dbo.[Order Details] od
ON o.OrderID = od.OrderID AND o.ShipPostalCode IS NOT NULL AND DATEDIFF(YEAR, CURRENT_TIMESTAMP, o.OrderDate) < 20 
GROUP BY o.ShipPostalCode

SELECT c.City "City", COUNT(c.CustomerID) "NumOfCustomers"
FROM dbo.Customers c
GROUP BY c.City

SELECT c.City "City", COUNT(c.CustomerID) "NumOfCustomers"
FROM dbo.Customers c
GROUP BY c.City
HAVING COUNT(c.CustomerID) > 10

SELECT c.CompanyName "Name"
FROM dbo.Customers c
JOIN dbo.Orders o
ON c.CustomerID = o.CustomerID AND o.OrderDate > '1/1/98'
GROUP BY c.CompanyName

SELECT c.CompanyName "Name", MAX(o.OrderDate) "RecentOrderDate"
FROM dbo.Customers c
JOIN dbo.Orders o
ON c.CustomerID = o.CustomerID
GROUP BY c.CompanyName

SELECT c.CompanyName "Name", SUM(od.Quantity) "Quantity"
FROM dbo.Customers c
JOIN dbo.Orders o
ON c.CustomerID = o.CustomerID
JOIN dbo.[Order Details] od
ON o.OrderID = od.OrderID
GROUP BY c.CompanyName

SELECT c.CustomerID "CusID", SUM(od.Quantity)
FROM dbo.Customers c
JOIN dbo.Orders o
ON c.CustomerID = o.CustomerID
JOIN dbo.[Order Details] od
ON o.OrderID = od.OrderID
GROUP BY c.CustomerID
HAVING SUM(od.Quantity) > 100

SELECT su.CompanyName "[Supplier Company Name]", sh.CompanyName "[Shipping Company Name]"
FROM dbo.Suppliers su
CROSS JOIN dbo.Shippers sh

SELECT o.OrderDate, p.ProductName
FROM dbo.Orders o
JOIN dbo.[Order Details] od
ON o.OrderID = od.OrderID
JOIN dbo.Products p
ON od.ProductID = p.ProductID
GROUP BY o.OrderDate, p.ProductName

SELECT e.FirstName + ' ' + e.LastName AS FirstPair, t.FirstName +' ' + t.LastName AS SecondPair
FROM dbo.Employees e
JOIN dbo.Employees t
ON e.Title = t.Title AND e.EmployeeID != t.EmployeeID

SELECT c.City AS City, c.CompanyName, c.ContactName, 'Customer' AS Type
FROM dbo.Customers c
UNION 
SELECT s.City AS City, s.CompanyName, s.ContactName, 'Supplier' AS Type
FROM dbo.Suppliers s
ORDER BY City
