# Data Analytics SQL Assessment

This repository contains SQL queries for a four-part analytics assessment based on a financial customer database. The goal is to demonstrate SQL proficiency in solving business problems related to customer segmentation, product adoption, and transaction behavior.

## Database Schema Overview

The assessment is based on the following four tables:

* **users\_customuser**: Contains demographic and contact information for customers.
* **savings\_savingsaccount**: Records of savings transactions (deposits).
* **plans\_plan**: Details of customer financial plans (savings, investments, etc.).
* **withdrawals\_withdrawal**: Records of withdrawals by customers.

## Questions and Solutions

### Q1. High-Value Customers with Multiple Products

**Objective**: Identify customers who have both a funded savings plan and a funded investment plan, and rank them by total deposits.

**Output**: `owner_id`, `name`, `savings_count`, `investment_count`, `total_deposits`

**Approach**:

* Join `users_customuser`, `plans_plan`, and `savings_savingsaccount`.
* Filter savings with `confirmed_amount > 0`.
* Count savings plans with `is_regular_savings = 1` and investment plans with `is_a_fund = 1`.
* Group and filter users who have at least one of each.

### Q2. Transaction Frequency Analysis

**Objective**: Classify customers by their average number of monthly transactions.

**Output**: `frequency_category`, `customer_count`, `avg_transactions_per_month`

**Approach**:

* Use a CTE to calculate the total number of transactions and the number of active months (based on the first and last transaction).
* Compute the average number of monthly transactions.
* Assign frequency categories based on thresholds: High (≥10), Medium (3-9), Low (≤2).
* Group results by frequency category.

### Q3. Account Inactivity Alert

**Objective**: Flag savings or investment plans with no inflow transactions for the past 365 days.

**Output**: `plan_id`, `owner_id`, `type`, `last_transaction_date`, `inactivity_days`

**Approach**:

* Join `plans_plan` and `savings_savingsaccount`.
* Group by plan to get the latest transaction date.
* Filter plans with `is_regular_savings = 1` or `is_a_fund = 1`, and with `last_transaction_date > 365` days ago.
* Tag type as 'Savings' or 'Investment'.

### Q4. Customer Lifetime Value (CLV) Estimation

**Objective**: Estimate each customer's lifetime value based on transaction volume and account tenure.

**Output**: `customer_id`, `name`, `tenure_months`, `total_transactions`, `estimated_clv`

**Approach**:

* Join `users_customuser` with `savings_savingsaccount`.

* Calculate `tenure_months` from `date_joined`.

* Count total transactions per customer.

* Estimate CLV using formula:

  **CLV = (transactions / tenure) \* 12 \* 0.1% \* average confirmed\_amount**

* Order by CLV descending.

---

## Challenges Encountered

1. **Overlapping Savings and Investment Plans**:

   * Ensuring that savings and investment plans were properly counted without duplication.
   * Used distinct `plan_id` counts and conditional aggregation for accuracy.

2. **Transaction Frequency Calculations**:

   * Customers with transactions in the same month needed careful handling to avoid zero division.
   
3. **Filtering Stale Accounts**:

   * Initially included all plans regardless of type or status. Adjusted filters to include only active (non-deleted) plans.

4. **CLV Logic and Division by Zero**:

   * Needed to safeguard against dividing by tenure = 0 months.

---

## Author

Rebekah Aranuwa

For inquiries or improvements, feel free to open a pull request or issue.
