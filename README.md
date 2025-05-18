DataAnalytics-Assessment
This repository contains solutions to a SQL proficiency assessment involving customer savings and investment data. The queries were written and tested using **PostgreSQL**.

Question Breakdown & Approach
**Q1: High-Value Customers with Multiple Products**

**Objective:**  
Find customers who have at least one funded savings plan and one funded investment plan, sorted by total deposits.

**Approach:**  
- Joined `plans_plan` twice using conditions:
  - `is_regular_savings = TRUE` (savings)
  - `is_a_fund = TRUE` (investments)
- Aggregated counts and summed `confirmed_amount` (converted from kobo to naira).

**Q2: Transaction Frequency Analysis**

**Objective:**  
Classify customers into High/Medium/Low frequency based on their average number of monthly savings transactions.

**Approach:**  
- Used `DATE_TRUNC('month', transaction_date)` to group transactions by month.
- Calculated average transactions per customer.
- Used `CASE` to assign frequency categories.

**Q3: Account Inactivity Alert**

**Objective:**  
Identify savings or investment accounts with no transactions in the last 365 days.

**Approach:**  
- Used `MAX(transaction_date)` per account.
- Unioned results from `savings_savingsaccount` and `plans_plan`.
- Filtered using `last_transaction_date < CURRENT_DATE - INTERVAL '365 days'`.

**Q4: Customer Lifetime Value (CLV) Estimation**

**Objective:**  
Estimate customer lifetime value using:
CLV = (total_transactions / tenure_months) * 12 * avg_profit_per_transaction

**Approach:**
- Calculated account tenure using `AGE(current_date, date_joined)`.
- Computed total transactions and total transaction value.
- Assumed profit per transaction is 0.1% of value.
- Used `NULLIF` and `CAST` to avoid division and rounding errors.

Tools & Technologies

- PostgreSQL 14+
- SQL (CTEs, Joins, Aggregates, Type Casting)

Challenges Encountered

- **Type casting errors**: PostgreSQL required explicit casting for `ROUND` on `double precision`. Resolved by converting expressions to `numeric`.
- **Interval vs integer confusion**: When calculating inactivity in days, replaced `DATE_PART` with clean interval comparisons to avoid ambiguity.

✅ Final Notes

- All monetary values are stored in **kobo**, so calculations were carefully scaled where needed.
- Queries are optimized and commented for clarity and reusability.
