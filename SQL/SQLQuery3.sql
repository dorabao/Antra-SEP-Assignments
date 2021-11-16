USE NorthWind

--Q1
SELECT e.City
FROM dbo.Employees e
JOIN dbo.Customers c
ON e.City = c.City
GROUP BY e.City

--Q2
SELECT c.City
FROM dbo.Customers c
WHERE c.City NOT IN (SELECT e.City FROM dbo.Employees e)
GROUP BY c.City

SELECT c.City
FROM dbo.Customers c
LEFT JOIN dbo.Employees e
ON c.City = e.City
WHERE e.City IS NULL
GROUP BY c.City

--Q3
SELECT p.ProductName, SUM(od.Quantity) AS OrderQuantities
FROM dbo.Products p
JOIN dbo.[Order Details] od
ON p.ProductID = od.ProductID
GROUP BY p.ProductName

--Q4
SELECT c.City, SUM(od.Quantity) AS TotalProducts
FROM dbo.Customers c
LEFT JOIN dbo.Orders o
ON c.CustomerID = o.CustomerID
JOIN dbo.[Order Details] od
ON o.OrderID = od.OrderID
GROUP BY c.City

--Q5
;WITH cte AS
(
	SELECT temp.City AS City, temp.CusID AS CusID, ROW_NUMBER() OVER(PARTITION BY temp.City ORDER BY temp.City) AS rowNum
	FROM (
		SELECT c.City AS City, c.CustomerID AS CusID
		FROM dbo.Customers c
		UNION
		SELECT tc.City, tc.CustomerID
		FROM dbo.Customers tc
	) AS temp
)
SELECT cte.City
FROM cte
WHERE rowNum >= 2
GROUP BY cte.City

SELECT c.City, COUNT(c.CustomerID) AS CusNum
FROM dbo.Customers c
GROUP BY c.City
HAVING COUNT(c.CustomerID) >= 2

--Q6
SELECT c.City, COUNT(od.ProductID) AS ProductsTypes
FROM dbo.Customers c
JOIN dbo.Orders o
ON c.CustomerID = o.CustomerID
JOIN dbo.[Order Details] od
ON o.OrderID = od.OrderID
GROUP BY c.City
HAVING COUNT(od.ProductID) > 2

--Q7
SELECT c.CompanyName, c.City, o.ShipCity
FROM dbo.Customers c
JOIN dbo.Orders o
ON c.CustomerID = o.CustomerID AND c.City != o.ShipCity
GROUP BY c.CompanyName, c.City, o.ShipCity

--Q8
;WITH topOrdercte AS
(
	SELECT od.OrderID, od.ProductID, MAX(od.Quantity) AS Quantity, ROW_NUMBER() OVER(PARTITION BY od.ProductID ORDER BY MAX(od.Quantity) DESC) AS MaxOrder
	FROM dbo.[Order Details] od
	WHERE od.ProductID IN (
		SELECT topSell.ProductID
		FROM (
			SELECT TOP 5 od.ProductID, SUM(od.Quantity) AS Quantity
			FROM dbo.[Order Details] od
			GROUP BY od.ProductID
			ORDER BY Quantity DESC
		) AS topSell
	)
	GROUP BY od.OrderID, od.ProductID
)
SELECT p.ProductName, p.UnitPrice, c.City
FROM topOrdercte
JOIN dbo.Products p
ON p.ProductID = topOrdercte.ProductID AND topOrdercte.MaxOrder = 1
JOIN dbo.Orders o
ON topOrdercte.OrderID = o.OrderID
JOIN dbo.Customers c
ON o.CustomerID = c.CustomerID

--Q9
SELECT e.City
FROM dbo.Employees e
WHERE e.City NOT IN (
	SELECT c.City
	FROM dbo.Customers c
	JOIN dbo.Orders o
	ON c.CustomerID = o.CustomerID
	GROUP BY c.City
)

SELECT e.City
FROM dbo.Employees e
LEFT JOIN (
	SELECT c.City
	FROM dbo.Customers c
	JOIN dbo.Orders o
	ON c.CustomerID = o.CustomerID
	GROUP BY c.City
) AS temp
ON e.City = temp.City 
WHERE temp.City IS NULL
GROUP BY e.City

--Q10
SELECT e.City, COUNT(o.OrderID) AS MostOrders
FROM dbo.Employees e
JOIN dbo.Orders o
ON e.EmployeeID = o.EmployeeID
JOIN (
	SELECT TOP 1 c.City, SUM(od.Quantity) AS MostProducts
	FROM dbo.Customers c
	LEFT JOIN dbo.Orders o
	ON c.CustomerID = o.CustomerID
	JOIN dbo.[Order Details] od
	ON o.OrderID = od.OrderID
	GROUP BY c.City
	ORDER BY MostProducts DESC
) AS temp
ON e.City = temp.City
GROUP BY e.City

