SELECT
    cat.CategoryName,
    COUNT(DISTINCT s.SupplierID) AS NumberOfUniqueSuppliers
FROM
    Suppliers AS s
JOIN
    Products AS p ON s.SupplierID = p.SupplierID
JOIN
    Categories AS cat ON p.CategoryID = cat.CategoryID
GROUP BY
    cat.CategoryName
ORDER BY
    NumberOfUniqueSuppliers DESC,
    cat.CategoryName ASC;