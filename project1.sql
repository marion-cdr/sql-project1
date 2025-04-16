.mode column
.headers on 

DROP TABLE IF EXISTS wallet;
DROP TABLE IF EXISTS ledger;

CREATE TABLE IF NOT EXISTS wallet (
    wallet_id INTEGER PRIMARY KEY,
    wallet_name VARCHAR(255) NOT NULL
);

CREATE TABLE IF NOT EXISTS ledger (
    ledger_id INTEGER PRIMARY KEY AUTOINCREMENT,
    wallet_id INTEGER,
    ledger_type VARCHAR(255) CHECK (ledger_type IN ('credit', 'debit')),
    amount REAL NOT NULL,
    transaction_date DATE NOT NULL
);

INSERT INTO wallet (wallet_id, wallet_name) VALUES 
    (1, "Wallet_A"),
    (2, "Wallet_B"),
    (3, "Wallet_C");


INSERT INTO ledger (wallet_id, ledger_type, amount, transaction_date) VALUES 
    (1, 'credit', 300.00, '2024-01-05'),
    (1, 'debit', 100.00, '2024-01-10'),
    (1, 'credit', 200.00, '2024-01-15'),
    (1, 'credit', 500.00, '2024-02-01'),
    (1, 'debit', 150.00, '2024-02-10'),
    (2, 'credit', 150.00, '2024-01-07'),
    (2, 'debit', 50.00, '2024-01-20'),
    (2, 'credit', 300.00, '2024-02-05'),
    (2, 'credit', 250.00, '2024-02-15'),
    (3, 'debit', 120.00, '2024-01-25'),
    (3, 'credit', 400.00, '2024-02-10'),
    (3, 'credit', 200.00, '2024-02-20'),
    (4, 'credit', 700.00, '2024-01-03'),
    (4, 'credit', 150.00, '2024-01-25'),
    (4, 'debit', 100.00, '2024-02-12'),
    (5, 'credit', 100.00, '2024-01-15'),
    (5, 'credit', 300.00, '2024-02-05'),
    (5, 'credit', 400.00, '2024-02-15'),
    (5, 'debit', 200.00, '2024-02-20'),
     (1, 'credit', 300.00, '2024-01-05'), -- Doublon
    (2, 'credit', 150.00, '2024-01-07'), -- Doublon
    (5, 'credit', 300.00, '2024-02-05'); -- Doublon



-- QUESTION 1
WITH wallet_ledger AS (
    SELECT 
        l.wallet_id, 
        strftime('%Y-%m', l.transaction_date) AS year_month,
        SUM(CASE WHEN ledger_type = "credit" THEN amount ELSE 0 END) AS total_credited,
        SUM(CASE WHEN ledger_type = "debit" THEN amount ELSE 0 END) AS total_debited
    FROM ledger l
    GROUP BY year_month, l.wallet_id
)
SELECT  
    wl.year_month,
    wl.wallet_id,
    w.wallet_name,
    wl.total_credited,
    wl.total_debited,
    wl.total_credited - wl.total_debited AS balance_monthly
FROM wallet_ledger wl
INNER JOIN wallet w ON w.wallet_id = wl.wallet_id;


-- QUESTION 2
SELECT  
    w.wallet_name,
    SUM(CASE WHEN ledger_type = "credit" THEN amount ELSE 0 END) AS total_credited
FROM ledger l
INNER JOIN wallet w ON w.wallet_id = l.wallet_id
GROUP BY l.wallet_id
ORDER BY total_credited DESC
LIMIT 2;


-- QUESTION 3
SELECT 
    l.wallet_id,
    l.ledger_type,
    l.amount,
    l.transaction_date,
    COUNT(*) AS count_duplicates
FROM ledger l 
GROUP BY 
    l.wallet_id,
    l.ledger_type,
    l.amount,
    l.transaction_date
HAVING count_duplicates > 1;

-- identify the ledger_id to DELETE them
WITH duplicates AS (
    SELECT 
        l.ledger_id,
        ROW_NUMBER() OVER (
            PARTITION BY 
                l.wallet_id, 
                l.ledger_type, 
                l.amount, 
                l.transaction_date
            ORDER BY l.ledger_id
        ) AS rn
    FROM ledger l
)
DELETE FROM ledger
WHERE ledger_id IN ( 
    SELECT ledger_id
    FROM duplicates
    WHERE rn > 1
);


-- QUESTION 4
SELECT 
    w.wallet_name,
    l.transaction_date,
    l.ledger_type,
    l.amount,
    SUM(
        CASE 
            WHEN l.ledger_type = 'credit' THEN l.amount
            WHEN l.ledger_type = 'debit' THEN -l.amount
            ELSE 0
        END
    ) OVER (
        PARTITION BY l.wallet_id          
        ORDER BY l.transaction_date       
        ROWS BETWEEN UNBOUNDED PRECEDING  
        AND CURRENT ROW                   
    ) AS running_balance
FROM ledger l
INNER JOIN wallet w ON w.wallet_id = l.wallet_id
ORDER BY w.wallet_name, l.transaction_date;


-- QUESTION 5
CREATE TRIGGER prevent_negative_balance
BEFORE INSERT ON ledger
FOR EACH ROW
WHEN NEW.ledger_type = 'debit'
BEGIN
    SELECT 
        CASE 
            WHEN (
                (SELECT 
                    COALESCE(
                        SUM(CASE 
                            WHEN l.ledger_type = 'credit' THEN l.amount
                            WHEN l.ledger_type = 'debit' THEN -l.amount
                            ELSE 0
                        END), 0
                    )
                FROM ledger l
                WHERE l.wallet_id = NEW.wallet_id
            ) - NEW.amount
        ) < 0
        THEN RAISE(ABORT, 'Transaction refusée : solde insuffisant')
        ELSE NULL
        END;
END;


