WITH txns AS (
    SELECT 
        owner_id, 
        COUNT(*) AS txn_count, 
        SUM(confirmed_amount) AS total_amount
    FROM savings_savingsaccount
    GROUP BY owner_id
),
tenure AS (
    SELECT 
        id AS customer_id,
        name,
        DATE_PART('month', AGE(CURRENT_DATE, date_joined))::int AS tenure_months
    FROM users_customuser
),
clv AS (
    SELECT 
        t.customer_id,
        t.name,
        t.tenure_months,
        COALESCE(tx.txn_count, 0) AS total_transactions,
        ROUND( 
            (
                (tx.txn_count::numeric / NULLIF(t.tenure_months, 0)) * 12 
                * ((tx.total_amount * 0.001)::numeric / NULLIF(tx.txn_count, 0))
            ), 
            2
        ) AS estimated_clv
    FROM tenure t
    LEFT JOIN txns tx ON t.customer_id = tx.owner_id
)
SELECT *
FROM clv
ORDER BY estimated_clv DESC;
