SELECT
    c.Country,
    c.City,
    COUNT(DISTINCT o.OrderID) AS TotalOrders,               -- Total number of unique orders from this city/country
    COUNT(DISTINCT c.CustomerID) AS UniqueCustomers,        -- Total number of unique customers in this city/country
    SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)) AS TotalSalesAmount, -- Total sales generated
    -- Calculate Average Order Value (Total Sales / Total Orders).
    -- Using NULLIF to prevent division by zero if there are no orders.
    CAST(SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)) AS DECIMAL(10,2)) / NULLIF(COUNT(DISTINCT o.OrderID), 0) AS AverageOrderValue
FROM
    Customers AS c
JOIN
    Orders AS o ON c.CustomerID = o.CustomerID
JOIN
    `Order Details` AS od ON o.OrderID = od.OrderID
GROUP BY
    c.Country,
    c.City
ORDER BY
    TotalSalesAmount DESC, -- Order primarily by total sales (highest first)
    c.Country ASC,         -- Then by country alphabetically
    c.City ASC
    limit 20;            -- Then by city alphabetically