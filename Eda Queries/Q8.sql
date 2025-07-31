SELECT
    Title,
    TitleOfCourtesy,
    COUNT(EmployeeID) AS NumberOfEmployees
FROM
    Employees
GROUP BY
    Title,
    TitleOfCourtesy
ORDER BY
    Title ASC, 
    NumberOfEmployees DESC; 