SELECT
    cat.CategoryName,
    YEAR(o.OrderDate) AS SalesYear,
    MONTH(o.OrderDate) AS SalesMonth,
    SUM(od.Quantity) AS TotalQuantitySold,
    SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)) AS TotalRevenue
FROM
    Orders AS o
JOIN
    `Order Details` AS od ON o.OrderID = od.OrderID
JOIN
    Products AS p ON od.ProductID = p.ProductID
JOIN
    Categories AS cat ON p.CategoryID = cat.CategoryID
GROUP BY
    cat.CategoryName,
    SalesYear,
    SalesMonth
ORDER BY
    cat.CategoryName ASC,
    SalesYear ASC,
    SalesMonth ASC;