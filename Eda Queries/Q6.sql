SELECT
    Country,
    Region, -- Region might be NULL for some countries, but it's good to include
    City,
    Title,
    COUNT(EmployeeID) AS NumberOfEmployees
FROM
    Employees
GROUP BY
    Country,
    Region,
    City,
    Title
ORDER BY
    Country ASC,
    City ASC,
    Title ASC;