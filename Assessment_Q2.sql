-- Q2_TransactionFrequencyAnalysis.sql
-- Objective: Categorize customers by average transaction frequency per month and return
-- Output: frequency_category, customer_count, avg_transactions_per_month

WITH txn_summary AS (
    SELECT 
        owner_id,
        COUNT(*) AS total_txns,
         -- Active months based on transaction history (at least 1 month to avoid division by zero)
        TIMESTAMPDIFF(MONTH, MIN(transaction_date), MAX(transaction_date)) AS tenure_months 
    FROM savings_savingsaccount
    WHERE confirmed_amount > 0
    GROUP BY owner_id
),
freq_calc AS (
    SELECT 
        owner_id,
        total_txns,
        tenure_months,
        ROUND(total_txns / NULLIF(tenure_months, 0), 2) AS avg_txn_per_month,
        CASE
            WHEN total_txns / NULLIF(tenure_months, 0) >= 10 THEN 'High Frequency'
            WHEN total_txns / NULLIF(tenure_months, 0) >= 3 THEN 'Medium Frequency'
            ELSE 'Low Frequency'
        END AS frequency_category
    FROM txn_summary
),
grouped AS (
    SELECT 
        frequency_category,
        COUNT(owner_id) AS customer_count,
        ROUND(AVG(avg_txn_per_month), 2) AS avg_transactions_per_month
    FROM freq_calc
    GROUP BY frequency_category
)

SELECT * FROM grouped
ORDER BY FIELD(frequency_category, 'High Frequency', 'Medium Frequency', 'Low Frequency');
