show databases;
use northwind;


SELECT
    CAST(COUNT(OrderID) AS DECIMAL(10,2)) / COUNT(DISTINCT CustomerID) AS AverageOrdersPerCustomer
FROM
    Orders;

-- METHOD 1
with CustomerOrderCount as(
select CustomerID, count(*) as OrderCount
from Orders
Group by CustomerID)

select avg(OrderCount) as AvgOrderperCustomer from CustomerOrderCount;

SELECT
    c.CustomerID,
    c.CompanyName,
    COUNT(o.OrderID) AS NumberOfOrders,
    SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)) AS TotalSalesAmount
FROM
    Customers AS c
JOIN
    Orders AS o ON c.CustomerID = o.CustomerID
JOIN
    `Order Details` AS od ON o.OrderID = od.OrderID
GROUP BY
    c.CustomerID, c.CompanyName
ORDER BY
    TotalSalesAmount DESC, NumberOfOrders DESC;
    

-- METHOD 2

WITH OrderTotalSales AS (
    -- Step 1: Calculate the total sales for each individual order
    SELECT
        OrderID,
        SUM(UnitPrice * Quantity * (1 - Discount)) AS OrderSalesAmount
    FROM
        `Order Details`
    GROUP BY
        OrderID
),
CustomerSalesAndOrderCounts AS (
    -- Step 2: Aggregate these order sales and count orders for each customer
    SELECT
        o.CustomerID,
        c.CompanyName, -- Get customer name from the Customers table
        COUNT(o.OrderID) AS NumberOfOrders,
        SUM(ots.OrderSalesAmount) AS TotalCustomerSales
    FROM
        Orders AS o
    JOIN
        OrderTotalSales AS ots ON o.OrderID = ots.OrderID
    JOIN
        Customers AS c ON o.CustomerID = c.CustomerID -- Join with Customers to get CompanyName
    GROUP BY
        o.CustomerID, c.CompanyName
)
-- Step 3: Select and order the results to find high-value repeat customers
SELECT
    CustomerID,
    CompanyName,
    NumberOfOrders,
    TotalCustomerSales
FROM
    CustomerSalesAndOrderCounts
WHERE
    NumberOfOrders > 1 -- Filter for repeat customers (more than 1 order)
ORDER BY
    TotalCustomerSales DESC, NumberOfOrders DESC
LIMIT 10; -- Show top 10 high-value repeat customers







-- method 3
SELECT
    c.CustomerID,
    c.CompanyName,
    COUNT(o.OrderID) AS NumberOfOrders,
    SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)) AS TotalSalesAmount
FROM
    Customers AS c
JOIN
    Orders AS o ON c.CustomerID = o.CustomerID
JOIN
    `Order Details` AS od ON o.OrderID = od.OrderID
GROUP BY
    c.CustomerID, c.CompanyName
ORDER BY
    TotalSalesAmount DESC, NumberOfOrders DESC
    limit 10;