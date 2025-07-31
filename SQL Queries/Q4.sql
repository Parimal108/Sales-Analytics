SELECT
    c.Country,
    c.City,
    cat.CategoryName,
    SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)) AS TotalRevenueForCategoryInLocation,
    SUM(od.Quantity) AS TotalQuantitySoldForCategoryInLocation,
    COUNT(DISTINCT o.OrderID) AS NumberOfOrdersContainingCategory
FROM
    Customers AS c
JOIN
    Orders AS o ON c.CustomerID = o.CustomerID
JOIN
    `Order Details` AS od ON o.OrderID = od.OrderID
JOIN
    Products AS p ON od.ProductID = p.ProductID
JOIN
    Categories AS cat ON p.CategoryID = cat.CategoryID
GROUP BY
    c.Country,
    c.City,
    cat.CategoryName
ORDER BY
    c.Country ASC,
    c.City ASC,
    TotalRevenueForCategoryInLocation DESC; -- See top categories by revenue within each city/country
    
    
    
    
    
    
    
 --    SELECT
--     cat.CategoryName,
--     SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)) AS TotalCategoryRevenue
-- FROM
--     `Order Details` AS od
-- JOIN
--     Products AS p ON od.ProductID = p.ProductID
-- JOIN
--     Categories AS cat ON p.CategoryID = cat.CategoryID
-- GROUP BY
--     cat.CategoryName
-- ORDER BY
--     TotalCategoryRevenue DESC
-- LIMIT 10; -- Show the top 10 categories
--     
--     
--     
--     
--    