--MSSQL PROJECT----UGOCHI SONIA AUDU

-- Select Statement
-- * means all

select *
from Production.Product;

-----------------1
SELECT 
    ProductID,
    Name,
    Color,
    ListPrice,
    StandardCost AS Price
FROM [Production].[Product]
WHERE 
    Color IS NOT NULL
    AND Color NOT IN ('Red', 'Silver/Black', 'White')
    AND ListPrice BETWEEN 75 AND 750
ORDER BY ListPrice DESC;


SELECT*
FROM HumanResources.Employee
-------------------2
SELECT *
FROM HumanResources.Employee
WHERE Gender = 'M'
AND YEAR(BirthDate) BETWEEN 1962 AND 1970
AND YEAR(HireDate) > 2001;

SELECT *
FROM HumanResources.Employee
WHERE Gender = 'F'
AND YEAR(BirthDate) BETWEEN 1972 AND 1975
AND YEAR(HireDate) BETWEEN 2001 AND 2002;

-----------------3
SELECT TOP 10 ProductID, Name, Color
FROM Production.Product 
WHERE ProductNumber LIKE 'BK%' 
ORDER BY ListPrice DESC;

-------------------4
SELECT FirstName, LastName, CONCAT(FirstName, ' ', LastName) AS FullName, LEN(CONCAT(FirstName, ' ', LastName)) AS FullNameLength
FROM Person.Person
WHERE LEFT(FirstName, 4) = LEFT(LastName, 4);

--------------------5
SELECT ps.Name AS SubcategoryName, AVG(p.DaysToManufacture) AS AverageDaysToManufacture
FROM Production.Product p
JOIN Production.ProductSubcategory ps ON p.ProductSubcategoryID = ps.ProductSubcategoryID
GROUP BY ps.Name
HAVING AVG(p.DaysToManufacture) >= 3;


SELECT ProductSubcategoryID, AVG(DaysToManufacture) AS AverageManufacturingDays
FROM Production.Product
GROUP BY ProductSubcategoryID
HAVING AVG(DaysToManufacture) >= 3
ORDER BY Avg(DaysToManufacture) DESC;


--------------------------6
SELECT 
    ProductID, 
    Name, 
    Color, 
    ListPrice,
    CASE 
        WHEN ListPrice < 200 THEN 'Low Value'
        WHEN ListPrice BETWEEN 201 AND 750 THEN 'Mid Value'
        WHEN ListPrice BETWEEN 751 AND 1250 THEN 'Mid to High Value'
        ELSE 'Higher Value'
    END AS PriceSegment
FROM Production.Product
WHERE Color IN ('Black', 'Silver', 'Red')
ORDER BY ProductID;

-------------7
SELECT COUNT(DISTINCT JobTitle) AS DistinctJobTitleCount
FROM [HumanResources].[Employee];

-------8
SELECT BusinessEntityID, DATEDIFF(YEAR, BirthDate, HireDate) AS AgeAtHiring
FROM [HumanResources].[Employee];

-----9
SELECT COUNT(*) AS LongServiceAwardCount
FROM [HumanResources].[Employee]
WHERE DATEDIFF(YEAR, HireDate, GETDATE()) >= 20
AND DATEDIFF(YEAR, HireDate, GETDATE()) < 25;

------10
SELECT BusinessEntityID, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age, 65 - DATEDIFF(YEAR, BirthDate, GETDATE()) AS YearsToRetirement
FROM [HumanResources].[Employee];

-----11
SELECT 
    ProductID,
    Name,
    Color,
    ListPrice,
    CASE 
        WHEN Color = 'White' THEN ListPrice * 1.08
        WHEN Color = 'Yellow' THEN ListPrice * 0.925
        WHEN Color = 'Black' THEN ListPrice * 1.172
        WHEN Color IN ('Multi', 'Silver', 'Silver/Black', 'Blue') THEN (SQRT(ListPrice) * 2)
        ELSE ListPrice
    END AS NewPrice,
    (CASE 
        WHEN Color = 'White' THEN ListPrice * 1.08
        WHEN Color = 'Yellow' THEN ListPrice * 0.925
        WHEN Color = 'Black' THEN ListPrice * 1.172
        WHEN Color IN ('Multi', 'Silver', 'Silver/Black', 'Blue') THEN (SQRT(ListPrice) * 2)
        ELSE ListPrice
    END) * 0.375 AS Commission
FROM Production.Product;

----- 12
SELECT 
    p.FirstName,
    p.LastName,
    e.HireDate,
    e.SickLeaveHours,
    st.Name AS Region,
    sqh.QuotaDate,
    sqh.SalesQuota
FROM Person.Person p
JOIN HumanResources.Employee e ON p.BusinessEntityID = e.BusinessEntityID
JOIN Sales.SalesPerson sp ON p.BusinessEntityID = sp.BusinessEntityID
JOIN Sales.SalesTerritory st ON sp.TerritoryID = st.TerritoryID
JOIN Sales.CountryRegionCurrency crc ON st.CountryRegionCode = crc.CountryRegionCode
JOIN Sales.SalesPersonQuotaHistory sqh ON sp.BusinessEntityID = sqh.BusinessEntityID
ORDER BY p.LastName, p.FirstName, sqh.QuotaDate;

------------------------13
SELECT 
    p.Name AS ProductName,
    pc.Name AS ProductCategoryName,
    psc.Name AS ProductSubcategoryName,
    CONCAT(e.FirstName, ' ', e.LastName) AS SalesPerson,
    SUM(sod.LineTotal) AS Revenue,
    MONTH(soh.OrderDate) AS TransactionMonth,
    CONCAT('Q', DATEPART(QUARTER, soh.OrderDate)) AS TransactionQuarter,
    s.Region
FROM [Sales].[SalesOrderHeader] soh
JOIN [Sales].[SalesOrderDetail] sod ON soh.SalesOrderID = sod.SalesOrderID
JOIN [Sales].[SalesTerritory] s ON soh.TerritoryID = s.TerritoryID
JOIN [Sales].[Customer] c ON soh.CustomerID = c.CustomerID
JOIN [Person].[Person] pe ON c.PersonID = pe.BusinessEntityID
JOIN [HumanResources].[Employee] e ON pe.BusinessEntityID = e.BusinessEntityID
JOIN [Production].[Product] p ON sod.ProductID = p.ProductID
JOIN [Production].[ProductSubcategory] psc ON p.ProductSubcategoryID = psc.ProductSubcategoryID
JOIN [Production].[ProductCategory] pc ON psc.ProductCategoryID = pc.ProductCategoryID
GROUP BY 
    p.Name,
    pc.Name,
    psc.Name,
    CONCAT(e.FirstName, ' ', e.LastName),
    MONTH(soh.OrderDate),
    DATEPART(QUARTER, soh.OrderDate),
    s.Region;

---------14

SELECT 
    soh.SalesOrderID AS OrderNumber,
    soh.OrderDate,
    soh.TotalDue AS OrderAmount,
    c.CustomerID,
    CONCAT(p.FirstName, ' ', p.LastName) AS CustomerName,
    CONCAT(e.FirstName, ' ', e.LastName) AS SalesmanName,
    soh.TotalDue * 0.0375 AS Commission
FROM [Sales].[SalesOrderHeader] soh
JOIN [Sales].[Customer] c ON soh.CustomerID = c.CustomerID
JOIN [Person].[Person] p ON c.PersonID = p.BusinessEntityID
LEFT JOIN [HumanResources].[Employee] e ON c.SalesPersonID = e.BusinessEntityID
ORDER BY soh.SalesOrderID;

---14
SELECT
    p.Name AS ProductName,
    pc.Name AS ProductCategoryName,
    psc.Name AS ProductSubcategoryName,
    e.LastName AS SalespersonName,
    sd.LineTotal AS Revenue,
    o.OrderDate,
    DATEPART(MONTH, o.OrderDate) AS MonthOfTransaction,
    DATEPART(QUARTER, o.OrderDate) AS QuarterOfTransaction,
    a.Name AS RegionName
FROM
    Sales.Product p
INNER JOIN
    Sales.ProductCategory pc
ON
    p.ProductCategoryID = pc.ProductCategoryID
LEFT JOIN
    Sales.ProductSubcategory psc
ON
    p.ProductSubCategoryID = psc.ProductSubcategoryID
INNER JOIN
    Sales.SalesOrderHeader o
ON
    p.ProductID = o.ProductID
INNER JOIN
    Sales.SalesOrderDetail sd
ON
    o.SalesOrderID = sd.SalesOrderID
INNER JOIN
    Person.Employee e
ON
    o.SalesPersonID = e.BusinessEntityID
INNER JOIN
    Sales.Customer a
ON
    o.CustomerID = a.CustomerID
ORDER BY
    ProductName,
    OrderDate;

----------15
SELECT 
    ProductID,
    Name,
    StandardCost,
    CASE
        WHEN Color = 'Black' THEN StandardCost * 1.22
        WHEN Color = 'Red' THEN StandardCost * 0.88
        WHEN Color = 'Silver' THEN StandardCost * 1.15
        WHEN Color = 'Multi' THEN StandardCost * 1.05
        WHEN Color = 'White' THEN 2 * StandardCost / SQRT(StandardCost)
        ELSE StandardCost
    END AS AdjustedCost,
    CASE
        WHEN Color IN ('Black', 'Red', 'Silver', 'Multi', 'White') THEN (AdjustedCost * 0.1479)
        ELSE (StandardCost * 0.1479)
    END AS Commission,
    CASE
        WHEN Color = 'Black' THEN (AdjustedCost - StandardCost) / StandardCost
        WHEN Color = 'Red' THEN (AdjustedCost - StandardCost) / StandardCost
        WHEN Color = 'Silver' THEN (AdjustedCost - StandardCost) / StandardCost
        WHEN Color = 'Multi' THEN (AdjustedCost - StandardCost) / StandardCost
        WHEN Color = 'White' THEN (AdjustedCost - (2 * StandardCost / SQRT(StandardCost))) / (2 * StandardCost / SQRT(StandardCost))
        ELSE 0
    END AS Margin
FROM [Production].[Product];[HumanResources].[Employee] AS e
ON p.BusinessEntityID = e.BusinessEntityID
ORDER BY soh.SalesOrderID;

Select *
From [HumanResources].[EmployeeDepartmentHistory]

----16 
SELECT
    p.ProductID,
    p.Name,
    p.Color,
    p.StandardCost
FROM
    (
        SELECT
            ProductID,
            Name,
            Color,
            StandardCost,
            ROW_NUMBER() OVER (PARTITION BY Color ORDER BY StandardCost DESC) AS RowNum
        FROM
            [Production].[Product]
    ) AS p
WHERE
    p.RowNum <= 5;

	----------16
	SELECT * FROM Top5MostExpensiveProductsByColor;




	

	
