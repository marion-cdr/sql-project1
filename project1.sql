.mode column 
.headers on 

DROP TABLE IF EXISTS wallet;
DROP TABLE IF EXISTS ledger;

CREATE TABLE IF NOT EXISTS wallet (
    wallet_id INTEGER,
    wallet_name VARCHAR(255) NOT NULL
);

CREATE TABLE IF NOT EXISTS ledger (
    ledger_id INTEGER PRIMARY KEY,
    wallet_id INTEGER,
    ledger_type VARCHAR(255) CHECK (ledger_type IN ('credit', 'debit')),
    amount REAL NOT NULL,
    transaction_date DATE
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

