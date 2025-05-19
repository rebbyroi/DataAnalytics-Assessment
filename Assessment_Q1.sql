-- Q1_HighValueCustomers.sql
-- Objective: Find customers with at least one funded savings plan AND one funded investment plan
-- Output: owner_id, name, savings_count, investment_count, total_deposits

SELECT 
    u.id AS owner_id,  -- Unique identifier of the customer
    CONCAT(u.first_name, ' ', u.last_name) AS name,
-- Count of distinct savings plans with confirmed deposits (funded savings)
    COUNT(DISTINCT CASE 
        WHEN p.is_regular_savings = 1 AND s.confirmed_amount > 0 
        THEN p.id 
    END) AS savings_count,

    COUNT(DISTINCT CASE 
        WHEN p.is_a_fund = 1 
        THEN p.id 
    END) AS investment_count,

    SUM(CASE 
        WHEN s.confirmed_amount > 0 THEN s.confirmed_amount 
        ELSE 0 
    END) AS total_deposits

FROM users_customuser u

-- Join savings transactions
JOIN savings_savingsaccount s 
    ON s.owner_id = u.id 
    AND s.confirmed_amount > 0

-- Join all related plans
JOIN plans_plan p 
    ON p.id = s.plan_id 
    AND p.owner_id = u.id

GROUP BY u.id, name

HAVING 
    savings_count > 0 AND 
    investment_count > 0

ORDER BY total_deposits DESC;
