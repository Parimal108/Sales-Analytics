SELECT
    o.OrderID,
    c.CompanyName AS CustomerName,
    o.OrderDate,
    SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)) AS TotalOrderValue
FROM
    Orders AS o
JOIN
    `Order Details` AS od ON o.OrderID = od.OrderID
JOIN
    Customers AS c ON o.CustomerID = c.CustomerID
GROUP BY
    o.OrderID, c.CompanyName, o.OrderDate
HAVING
    TotalOrderValue > (
        SELECT AVG(Sub.CalculatedTotalOrderValue) * 3 -- Flag orders that are, for example, 3 times higher than the average
        FROM (
            SELECT SUM(UnitPrice * Quantity * (1 - Discount)) AS CalculatedTotalOrderValue
            FROM `Order Details`
            GROUP BY OrderID
        ) AS Sub
    )
ORDER BY
    TotalOrderValue DESC;