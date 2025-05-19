-- Q4_CLVEstimation.sql
-- Objective: Estimate CLV for each customer
-- Output: customer_id, name, tenure_months, total_transactions, estimated_clv

WITH txn_data AS (
    SELECT 
        owner_id AS customer_id,
        COUNT(*) AS total_transactions,
        SUM(confirmed_amount) AS total_value
    FROM savings_savingsaccount
    WHERE confirmed_amount > 0
    GROUP BY owner_id
),
tenure_data AS (
    SELECT 
        id AS customer_id,
        CONCAT(first_name, ' ',last_name) AS name,
	-- Months since signup
        TIMESTAMPDIFF(MONTH, date_joined, CURDATE()) AS tenure_months
    FROM users_customuser
),
clv_calc AS (
    SELECT 
        t.customer_id,
        t.name,
        t.tenure_months,
        td.total_transactions,
        -- Simplified CLV formula: (transactions/month) * 12 * average profit per transaction
		-- profit per transaction = 0.1% (i.e., 0.001)
        ROUND((td.total_transactions / NULLIF(t.tenure_months, 0)) * 12 * ((td.total_value * 0.001) / td.total_transactions), 2) AS estimated_clv
    FROM tenure_data t
    JOIN txn_data td ON td.customer_id = t.customer_id
)

SELECT * 
FROM clv_calc
ORDER BY estimated_clv DESC;
