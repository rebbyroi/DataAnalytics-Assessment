-- Q3_AccountInactivityAlert.sql
-- Objective: Find active plans with no inflow transaction in last 365 days
-- Output: plan_id, owner_id, type, last_transaction_date, inactivity_days

WITH last_txn AS (
    SELECT 
        s.plan_id,
        s.owner_id,
        MAX(s.transaction_date) AS last_transaction_date -- Days since last inflow
    FROM savings_savingsaccount s
    WHERE s.confirmed_amount > 0
    GROUP BY s.plan_id, s.owner_id
),
relevant_plans AS (
    SELECT 
        p.id AS plan_id,
        p.owner_id,
        CASE 
            WHEN p.is_regular_savings = 1 THEN 'Savings'
            WHEN p.is_a_fund = 1 THEN 'Investment'
            ELSE 'Other'
        END AS type
    FROM plans_plan p
    WHERE p.is_regular_savings = 1 OR p.is_a_fund = 1
),
inactive AS (
    SELECT 
        rp.plan_id,
        rp.owner_id,
        rp.type,
        lt.last_transaction_date,
        DATEDIFF(CURDATE(), lt.last_transaction_date) AS inactivity_days
    FROM relevant_plans rp
    LEFT JOIN last_txn lt ON lt.plan_id = rp.plan_id
    WHERE DATEDIFF(CURDATE(), lt.last_transaction_date) > 365
)

SELECT * FROM inactive
ORDER BY inactivity_days DESC;
