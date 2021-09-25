USE AdventureWorks2019
GO

WITH sales_CTE
AS
-- Define the CTE query.
(
	SELECT soh.[SalesPersonID], 
	p.[FirstName] + ' ' + COALESCE (p.[MiddleName], '') + ' ' + p.[LastName] AS [FullName], 
	e.[JobTitle], 
	st.[Name] AS [SalesTerritory], 
	soh.[SubTotal], 
	YEAR(DATEADD(m, 6, soh.[OrderDate])) AS [FiscalYear]
	FROM  [Sales].[SalesPerson] sp INNER JOIN
	[Sales].[SalesOrderHeader] soh ON sp.[BusinessEntityID] = soh.[SalesPersonID] 
	INNER JOIN [Sales].[SalesTerritory] st ON sp.[TerritoryID] = st.[TerritoryID] 
	INNER JOIN [HumanResources].[Employee] e ON soh.[SalesPersonID] = e.[BusinessEntityID] 
	INNER JOIN [Person].[Person] p ON p.[BusinessEntityID] = sp.[BusinessEntityID]
)

-- Define the outer query referencing the CTE name.  
SELECT *  
FROM Sales_CTE;  
 

DECLARE @datetime1 datetime,
		@datetime2 datetime;  
SET @datetime1 = '1-Aug-2019';
SET @datetime2 = '1-Mar-2019';
--Statement                                 Result     
-------------------------------------------------------------------   
SELECT YEAR(DATEADD(m,6,@datetime1)) AS [FiscalYear];     -- 2020-02-02 00:00:00.000 
SELECT YEAR(DATEADD(m,6,@datetime2)) AS [FiscalYear];     -- 2019-09-01 00:00:00.000   


-- PIVOT

SELECT DaysToManufacture, AVG(StandardCost) AS AverageCost FROM Production.Product GROUP BY DaysToManufacture; 


SELECT *
FROM (
	SELECT  soh.[SalesPersonID], 
	p.[FirstName] + ' ' + COALESCE (p.[MiddleName], '') + ' ' + p.[LastName] AS [FullName], 
	e.[JobTitle], st.[Name] AS [SalesTerritory], soh.[SubTotal], YEAR(DATEADD(m, 6, soh.[OrderDate])) [FiscalYear] 
	FROM  [Sales].[SalesPerson] sp 
		INNER JOIN [Sales].[SalesOrderHeader] soh ON sp.[BusinessEntityID] = soh.[SalesPersonID] 
		INNER JOIN [Sales].[SalesTerritory] st ON sp.[TerritoryID] = st.[TerritoryID] 
		INNER JOIN [HumanResources].[Employee] e ON soh.[SalesPersonID] = e.[BusinessEntityID] 
INNER JOIN [Person].[Person] p ON p.[BusinessEntityID] = sp.[BusinessEntityID]) AS soh 
			
			PIVOT (AVG([SubTotal]) FOR [FiscalYear] IN ([2012], [2013], [2014])
	) AS pvt;


WITH sales_CTE
AS
(
	SELECT soh.[SalesPersonID], 
	p.[FirstName] + ' ' + COALESCE (p.[MiddleName], '') + ' ' + p.[LastName] AS [FullName], 
	e.[JobTitle], 
	st.[Name] AS [SalesTerritory], 
	soh.[SubTotal], 
	YEAR(DATEADD(m, 6, soh.[OrderDate])) AS [FiscalYear]
	FROM  [Sales].[SalesPerson] sp INNER JOIN
	[Sales].[SalesOrderHeader] soh ON sp.[BusinessEntityID] = soh.[SalesPersonID] 
	INNER JOIN [Sales].[SalesTerritory] st ON sp.[TerritoryID] = st.[TerritoryID] 
	INNER JOIN [HumanResources].[Employee] e ON soh.[SalesPersonID] = e.[BusinessEntityID] 
	INNER JOIN [Person].[Person] p ON p.[BusinessEntityID] = sp.[BusinessEntityID]
)
SELECT *
FROM sales_CTE

PIVOT (AVG([SubTotal]) FOR [FiscalYear] IN ([2012], [2013], [2014])
	) AS pvt;
