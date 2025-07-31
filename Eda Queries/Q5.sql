-- WITH CustomerOrderHistory AS (
--     -- Step 1: Get each customer's orders, ordered by date, and identify the previous order date
--     SELECT
--         o.CustomerID,
--         o.OrderDate,
--         LAG(o.OrderDate, 1) OVER (PARTITION BY o.CustomerID ORDER BY o.OrderDate ASC) AS PreviousOrderDate
--     FROM
--         Orders AS o
-- ),
-- OrderIntervals AS (
--     -- Step 2: Calculate the number of days between consecutive orders for each customer
--     SELECT
--         coh.CustomerID,
--         coh.OrderDate,
--         coh.PreviousOrderDate,
--         DATEDIFF(coh.OrderDate, coh.PreviousOrderDate) AS DaysBetweenOrders
--     FROM
--         CustomerOrderHistory AS coh
--     WHERE
--         coh.PreviousOrderDate IS NOT NULL -- Exclude the first order for each customer, as it has no previous order
--         AND DATEDIFF(coh.OrderDate, coh.PreviousOrderDate) > 0 -- Exclude same-day multiple orders if you want distinct days
-- ),
-- AverageCustomerFrequency AS (
--     -- Step 3: Calculate the average days between orders for each customer
--     SELECT
--         o.CustomerID,
--         c.CompanyName, -- Join back to Customers to get company name
--         COUNT(o.OrderID) AS TotalOrdersPlaced, -- Total orders to understand customer activity
--         AVG(o.OrderDate) AS FirstOrderDate, -- To understand their purchasing timeline
--         MAX(o.OrderDate) AS LastOrderDate,
--         AVG(DaysBetweenOrders) AS AvgDaysBetweenOrders -- This is our key frequency metric
--     FROM
--         Orders AS o
--     LEFT JOIN
--         OrderIntervals AS oi ON o.CustomerID = oi.CustomerID AND o.OrderDate = oi.OrderDate
--     JOIN
--         Customers AS c ON o.CustomerID = c.CustomerID
--     GROUP BY
--         o.CustomerID, c.CompanyName
--     HAVING
--         COUNT(o.OrderID) > 1 -- Only consider customers with more than one order to calculate an average interval
-- )
-- -- Step 4: Categorize customers into frequency segments and count them
-- SELECT
--     CASE
--         WHEN AvgDaysBetweenOrders IS NULL THEN 'Single Order Customer' -- Customers who only ordered once
--         WHEN AvgDaysBetweenOrders <= 30 THEN 'Highly Frequent (Monthly or more)'
--         WHEN AvgDaysBetweenOrders > 30 AND AvgDaysBetweenOrders <= 90 THEN 'Frequent (Quarterly)'
--         WHEN AvgDaysBetweenOrders > 90 AND AvgDaysBetweenOrders <= 180 THEN 'Occasional (Bi-Annual)'
--         WHEN AvgDaysBetweenOrders > 180 AND AvgDaysBetweenOrders <= 365 THEN 'Semi-Annual (Yearly)'
--         ELSE 'Rare (Less than Yearly)'
--     END AS CustomerFrequencySegment,
--     COUNT(CustomerID) AS NumberOfCustomersInSegment,
--     TRUNCATE(AVG(AvgDaysBetweenOrders), 2) AS AverageDaysInSegment -- Average days for this segment
-- FROM
--     AverageCustomerFrequency
-- GROUP BY
--     CustomerFrequencySegment
-- ORDER BY
--     CASE
--         WHEN CustomerFrequencySegment = 'Highly Frequent (Monthly or more)' THEN 1
--         WHEN CustomerFrequencySegment = 'Frequent (Quarterly)' THEN 2
--         WHEN CustomerFrequencySegment = 'Occasional (Bi-Annual)' THEN 3
--         WHEN CustomerFrequencySegment = 'Semi-Annual (Yearly)' THEN 4
--         WHEN CustomerFrequencySegment = 'Rare (Less than Yearly)' THEN 5
--         ELSE 6 -- For 'Single Order Customer'
--     END;




SELECT
    CASE
        WHEN TotalOrders = 1 THEN 'One-Time Buyer'
        WHEN TotalOrders BETWEEN 2 AND 5 THEN 'Low-Frequency Buyer (2-5 orders)'
        WHEN TotalOrders BETWEEN 6 AND 15 THEN 'Medium-Frequency Buyer (6-15 orders)'
        ELSE 'High-Frequency Buyer (16+ orders)'
    END AS CustomerOrderFrequencySegment,
    COUNT(CustomerID) AS NumberOfCustomersInSegment,
    SUM(TotalOrders) AS TotalOrdersBySegment -- See total orders placed by this segment
FROM (
    -- Subquery: Calculate the total number of orders for each customer
    SELECT
        CustomerID,
        COUNT(OrderID) AS TotalOrders
    FROM
        Orders
    GROUP BY
        CustomerID
) AS CustomerOrderCounts
GROUP BY
    CustomerOrderFrequencySegment
ORDER BY
    CASE -- Custom ordering for logical segment display
        WHEN CustomerOrderFrequencySegment = 'High-Frequency Buyer (16+ orders)' THEN 1
        WHEN CustomerOrderFrequencySegment = 'Medium-Frequency Buyer (6-15 orders)' THEN 2
        WHEN CustomerOrderFrequencySegment = 'Low-Frequency Buyer (2-5 orders)' THEN 3
        WHEN CustomerOrderFrequencySegment = 'One-Time Buyer' THEN 4
        ELSE 5 -- Fallback for any unexpected segment names
    END;