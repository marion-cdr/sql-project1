# Wallet Ledger SQL Project 💳📊

This is a beginner data analysis project using **SQLite**. It simulates wallet transactions (credits and debits) and includes SQL queries to analyze the data.

## 📁 Project Structure

- `project1.sql` – SQLite script to create tables, insert data, and run analysis queries.
- `screenshots/` – Optional folder for including screenshots of results or charts.

## 📊 Covered Topics

- Aggregate functions (SUM, COUNT)
- Grouping by month and wallet
- Detecting and removing duplicates
- Window functions (running balance)
- SQL Triggers (preventing overdraft)

## 🔧 How to Use

1. Open a SQLite client (e.g. [DB Browser for SQLite](https://sqlitebrowser.org/)).
2. Create a new database and run the `project1.sql` file.
3. Explore the queries and results!


## 📌 Exercises

1. **Analyze monthly transactions:**  
   For each wallet and month (`YYYY-MM`), calculate:
   - Total credited (`total_credited`)
   - Total debited (`total_debited`)
   - Monthly balance (`credit - debit`)

2. **Top 3 credited wallets:**  
   Return the 2 wallets with the highest total credited amounts.

3. **Detect duplicate transactions:**  
   Find duplicate rows based on the same `wallet_id`, `ledger_type`, `amount`, and `transaction_date`.

4. **Calculate running balance:**  
   Show the cumulative balance over time for each wallet using window functions.

5. **Trigger to prevent overdraft:**  
   Create a trigger that blocks debit transactions if the resulting balance would be negative.

---

