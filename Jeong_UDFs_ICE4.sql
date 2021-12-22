/* ----DBAS 4002-700----------
Jeong Eun Jang (w0451032)
----------ICE4------------- */


--Question 1. 

--- returns a single data value
CREATE FUNCTION dbo.ufnGetFiscalYear(@DT date)  
RETURNS int   
AS   
-- Returns the Fiscal Year based on a date parameter. 
BEGIN  
    DECLARE @ret int;  
    SELECT @ret = Year(DATEADD(m, 6, @DT)) 
     IF (@ret IS NULL)   
        SET @ret = 0;  
    RETURN @ret;  
END; 

--Usage

SELECT dbo.ufnGetFiscalYear(convert(datetime, '2020-08-23')) as FiscalYear



-- Question 2 

-- Create an inline table

IF OBJECT_ID (N'sales.ufnRankinigOfSalesYTD', N'IF') IS NOT NULL 
	DROP FUNCTION sales.ufnRankingOfSalesYTD;
GO

CREATE FUNCTION sales.ufn_RankingOfSalesYTD (@TerritoryName nvarchar(50))  
RETURNS TABLE  
AS  
RETURN  
(  
    SELECT FirstName, LastName, TerritoryName, ROUND(SalesYTD,2,1) AS SalesYTD, SalesQuota,
	ROW_NUMBER() OVER(PARTITION BY TerritoryName ORDER BY SalesYTD DESC) 
	  AS [Ranking]
	FROM Sales.vSalesPerson  
	WHERE SalesYTD <> 0 AND TerritoryName = @TerritoryName
);  

--USAGE

SELECT * FROM sales.ufn_RankingOfSalesYTD('Canada'); 

