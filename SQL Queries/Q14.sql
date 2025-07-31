SELECT
    s.Country AS SupplierCountry,
    s.City AS SupplierCity, -- Include City for more granularity, or remove for broader regional view
    cat.CategoryName,
    COUNT(DISTINCT s.SupplierID) AS NumberOfUniqueSuppliers, -- How many distinct suppliers in this location supply this category
    TRUNCATE(AVG(p.UnitPrice), 2) AS AverageUnitPriceForCategoryInRegion,
    TRUNCATE(MIN(p.UnitPrice), 2) AS MinimumUnitPriceForCategoryInRegion,
    TRUNCATE(MAX(p.UnitPrice), 2) AS MaximumUnitPriceForCategoryInRegion
FROM
    Suppliers AS s
JOIN
    Products AS p ON s.SupplierID = p.SupplierID
JOIN
    Categories AS cat ON p.CategoryID = cat.CategoryID
GROUP BY
    s.Country,
    s.City, -- Group by City if you included it above
    cat.CategoryName
ORDER BY
    SupplierCountry ASC,
    SupplierCity ASC, -- Order by City if you included it above
    CategoryName ASC,
    AverageUnitPriceForCategoryInRegion ASC; -- Sort to compare prices within a category for a region