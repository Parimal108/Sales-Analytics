WITH CustomerSpendAndOrders AS (
    -- Calculate Total Spend and Total Orders for each customer
    SELECT
        c.CustomerID,
        c.CompanyName,
        COUNT(DISTINCT o.OrderID) AS TotalOrders,
        SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)) AS TotalSpend
    FROM
        Customers AS c
    JOIN
        Orders AS o ON c.CustomerID = o.CustomerID
    JOIN
        `Order Details` AS od ON o.OrderID = od.OrderID
    GROUP BY
        c.CustomerID, c.CompanyName
),
CustomerCategoryPurchases AS (
    -- Calculate how many items each customer bought from each category
    SELECT
        o.CustomerID,
        p.CategoryID,
        cat.CategoryName,
        SUM(od.Quantity) AS TotalQuantityPurchasedInCategory
    FROM
        Orders AS o
    JOIN
        `Order Details` AS od ON o.OrderID = od.OrderID
    JOIN
        Products AS p ON od.ProductID = p.ProductID
    JOIN
        Categories AS cat ON p.CategoryID = cat.CategoryID
    GROUP BY
        o.CustomerID, p.CategoryID, cat.CategoryName
),
RankedCustomerCategories AS (
    -- Rank categories for each customer based on purchased quantity
    SELECT
        CustomerID,
        CategoryName,
       TotalQuantityPurchasedInCategory,
        ROW_NUMBER() OVER (PARTITION BY CustomerID ORDER BY TotalQuantityPurchasedInCategory DESC) AS rn
    FROM
        CustomerCategoryPurchases
)
SELECT
    cso.CustomerID,
    cso.CompanyName,
    cso.TotalOrders,
    cso.TotalSpend,
    rcc.CategoryName AS MostPreferredCategory -- The category with the highest quantity purchased
FROM
    CustomerSpendAndOrders AS cso
LEFT JOIN -- Use LEFT JOIN to include customers who might not have a distinct preferred category (e.g., only one order, or tie)
    RankedCustomerCategories AS rcc ON cso.CustomerID = rcc.CustomerID AND rcc.rn = 1;
    
    
    

  