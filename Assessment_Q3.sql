WITH savings_txns AS (
    SELECT 
        id AS plan_id,
        owner_id,
        'Savings' AS type,
        MAX(transaction_date) AS last_transaction_date
    FROM savings_savingsaccount
    GROUP BY id, owner_id
),
investment_txns AS (
    SELECT 
        id AS plan_id,
        owner_id,
        'Investment' AS type,
        MAX(transaction_date) AS last_transaction_date
    FROM plans_plan
    GROUP BY id, owner_id
),
all_txns AS (
    SELECT * FROM savings_txns
    UNION ALL
    SELECT * FROM investment_txns
)
SELECT 
    plan_id,
    owner_id,
    type,
    last_transaction_date,
    (CURRENT_DATE - last_transaction_date) AS inactivity_days
FROM all_txns
WHERE last_transaction_date < CURRENT_DATE - INTERVAL '365 days';
