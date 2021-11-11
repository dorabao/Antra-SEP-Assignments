USE AdventureWorks2019

SELECT ProductID, Name, Color, ListPrice
FROM Production.Product

SELECT ProductID, Name, Color, ListPrice
FROM Production.Product
WHERE ListPrice = 0

SELECT ProductID, Name, Color, ListPrice
FROM Production.Product
WHERE Color IS NULL

SELECT ProductID, Name, Color, ListPrice
FROM Production.Product
WHERE Color IS NOT NULL

SELECT ProductID, Name, Color, ListPrice
FROM Production.Product
WHERE Color IS NOT NULL AND ListPrice > 0

SELECT Name + ' ' + Color "NameAndColor"
FROM Production.Product
WHERE Color IS NOT NULL

SELECT 'NAME:'+ Name + ' -- ' + 'COLOR:' + Color "Name And Color"
FROM Production.Product
WHERE Name IS NOT NULL AND Color IS NOT NULL

SELECT ProductID, Name, Color, ListPrice
FROM Production.Product
WHERE Color IS NOT NULL

SELECT ProductID, Name
FROM Production.Product
WHERE ProductID BETWEEN 400 AND 500

SELECT ProductID, Name, Color
FROM Production.Product
WHERE Color IN ('Black', 'Blue')

SELECT Name "Products"
FROM Production.Product
WHERE Name LIKE 'S%'

SELECT Name, ListPrice
FROM Production.Product
WHERE Name LIKE 'S%'
ORDER BY Name 

SELECT Name, ListPrice
FROM Production.Product
WHERE Name LIKE '[A, S]%'
ORDER BY Name 

SELECT Name
FROM Production.Product
WHERE Name LIKE 'SPO[^K]%'
ORDER BY Name 

SELECT DISTINCT Color
FROM Production.Product
ORDER BY Color DESC

SELECT DISTINCT ProductSubcategoryID, Color
FROM Production.Product
WHERE ProductSubcategoryID IS NOT NULL AND Color IS NOT NULL

SELECT ProductSubcategoryID, LEFT([Name], 35) AS[Name], Color, ListPrice
FROM Production.Product
WHERE Color NOT IN ('Red', 'Black') OR (ListPrice BETWEEN 1000 AND 2000 AND ProductSubcategoryID = 1)
ORDER BY ProductID

--Can't figure it out!
SELECT distinct ProductSubcategoryID, Name, Color, ListPrice
FROM Production.Product
WHERE ProductSubcategoryID < 15 AND (Color NOT IN ('Black') OR Name LIKE '%58' OR ListPrice < 1000)
ORDER BY ProductSubcategoryID DESC, Name ASC