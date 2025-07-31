SELECT
    p.ProductID,
    p.ProductName,
    p.UnitPrice AS BaseUnitPrice, -- The standard unit price from the Products table
    p.UnitsInStock,                -- Current stock level
    p.UnitsOnOrder,                -- Units currently on order from suppliers
    SUM(od.Quantity) AS TotalQuantitySold,
    SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)) AS TotalRevenue,
    -- Average price at which the product was actually sold (considering discounts)
    CAST(SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)) AS DECIMAL(10,2)) / NULLIF(SUM(od.Quantity), 0) AS AverageSellingPrice
FROM
    Products AS p
LEFT JOIN -- Use LEFT JOIN to include all products, even those with no sales yet
    `Order Details` AS od ON p.ProductID = od.ProductID
GROUP BY
    p.ProductID,
    p.ProductName,
    p.UnitPrice,
    p.UnitsInStock,
    p.UnitsOnOrder
ORDER BY
    TotalRevenue DESC, p.ProductName ASC; -- Order by total revenue to see top sellers easily