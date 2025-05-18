CREATE TABLE users_customuser (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100),
    date_joined DATE
);

-- 2. savings_savingsaccount: Deposit transactions
CREATE TABLE savings_savingsaccount (
    id SERIAL PRIMARY KEY,
    owner_id INTEGER REFERENCES users_customuser(id),
    confirmed_amount BIGINT, -- in kobo
    transaction_date DATE
);

-- 3. plans_plan: Investment and savings plan information
CREATE TABLE plans_plan (
    id SERIAL PRIMARY KEY,
    owner_id INTEGER REFERENCES users_customuser(id),
    is_regular_savings BOOLEAN,
    is_a_fund BOOLEAN,
    confirmed_amount BIGINT, -- in kobo
    transaction_date DATE
);

-- 4. withdrawals_withdrawal: Withdrawal transactions
CREATE TABLE withdrawals_withdrawal (
    id SERIAL PRIMARY KEY,
    owner_id INTEGER REFERENCES users_customuser(id),
    amount_withdrawn BIGINT, -- in kobo
    transaction_date DATE
);

-- Insert users
INSERT INTO users_customuser (name, email, date_joined) VALUES
('John Doe', 'john@example.com', '2021-01-01'),
('Jane Smith', 'jane@example.com', '2022-06-15');

-- Insert savings deposits
INSERT INTO savings_savingsaccount (owner_id, confirmed_amount, transaction_date) VALUES
(1, 1000000, '2023-01-10'),
(1, 500000, '2023-03-05'),
(2, 200000, '2024-02-12');

-- Insert plans (investments/savings)
INSERT INTO plans_plan (owner_id, is_regular_savings, is_a_fund, confirmed_amount, transaction_date) VALUES
(1, TRUE, FALSE, 1000000, '2023-01-10'), -- savings plan
(1, FALSE, TRUE, 500000, '2023-02-15'), -- investment plan
(2, TRUE, FALSE, 200000, '2023-05-20');

SELECT 
    u.id AS owner_id,
    u.name,
    COUNT(DISTINCT s.id) AS savings_count,
    COUNT(DISTINCT i.id) AS investment_count,
    ROUND(SUM(s.confirmed_amount + i.confirmed_amount) / 100.0, 2) AS total_deposits
FROM users_customuser u
LEFT JOIN plans_plan s ON u.id = s.owner_id AND s.is_regular_savings = TRUE
LEFT JOIN plans_plan i ON u.id = i.owner_id AND i.is_a_fund = TRUE
WHERE s.id IS NOT NULL AND i.id IS NOT NULL
GROUP BY u.id, u.name
ORDER BY total_deposits DESC;
