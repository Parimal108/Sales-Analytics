SELECT
    s.Country AS SupplierCountry,
    s.City AS SupplierCity,
    cat.CategoryName,
    TRUNCATE(AVG(p.UnitPrice), 2) AS AverageProductUnitPriceInCategory
FROM
    Suppliers AS s
JOIN
    Products AS p ON s.SupplierID = p.SupplierID
JOIN
    Categories AS cat ON p.CategoryID = cat.CategoryID
GROUP BY
    s.Country,
    s.City,
    cat.CategoryName
ORDER BY
    SupplierCountry ASC,
    SupplierCity ASC,
    AverageProductUnitPriceInCategory ASC; -- Order to compare prices within a region/category