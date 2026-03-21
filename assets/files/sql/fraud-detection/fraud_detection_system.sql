-- =====================================================
-- PROJECT  : Fraud Detection Monitoring System
-- Author   : Moreen Gatwiri
-- Tool     : MySQL
-- Domain   : Financial Crime & Risk Analytics
-- Description:
--   SQL project detecting suspicious transactions,
--   rapid transfer activity, high-risk customers,
--   and geographic transaction hotspots.
-- =====================================================


-- =====================================================
-- SECTION 1 — DATABASE SETUP
-- =====================================================

CREATE DATABASE fraud_detection_system;

USE fraud_detection_system;


-- =====================================================
-- SECTION 2 — CREATE TABLES
-- =====================================================

CREATE TABLE customers (
    customer_id   INT PRIMARY KEY,
    customer_name VARCHAR(100),
    risk_score    INT
);

CREATE TABLE accounts (
    account_id  INT PRIMARY KEY,
    customer_id INT,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE transactions (
    transaction_id   INT PRIMARY KEY,
    sender_account   INT,
    recipient_account VARCHAR(20),
    transaction_type  VARCHAR(50),
    amount            DECIMAL(15,2),
    transaction_date  DATETIME,
    city              VARCHAR(50),
    FOREIGN KEY (sender_account) REFERENCES accounts(account_id)
);


-- =====================================================
-- SECTION 3 — ANALYSIS QUERIES
-- =====================================================

-- -----------------------------------------------------
-- Business Question 1: High-Value Transaction Detection
--   Which transactions exceed the normal
--   high-value monitoring threshold?
-- -----------------------------------------------------
SELECT
    transaction_id,
    sender_account,
    recipient_account,
    amount,
    transaction_date,
    city
FROM transactions
WHERE amount > 1000000
ORDER BY amount DESC;


-- -----------------------------------------------------
-- Business Question 2: Rapid Transfer Activity
--   Which accounts perform many transfers
--   within a short period?
-- -----------------------------------------------------
SELECT
    sender_account,
    COUNT(*) AS transfer_count
FROM transactions
WHERE transaction_type = 'Transfer'
GROUP BY sender_account
HAVING COUNT(*) >= 3;


-- -----------------------------------------------------
-- Business Question 3: Distributed Recipient Patterns
--   Which accounts send money to many
--   different recipients?
-- -----------------------------------------------------
SELECT
    sender_account,
    COUNT(DISTINCT recipient_account) AS number_of_recipients
FROM transactions
GROUP BY sender_account
HAVING number_of_recipients > 3;


-- -----------------------------------------------------
-- Business Question 4: High-Risk Customer Transactions
--   Which high-risk customers perform
--   large transactions?
-- -----------------------------------------------------
SELECT
    c.customer_name,
    c.risk_score,
    t.amount,
    t.transaction_date
FROM customers c
JOIN accounts a     ON c.customer_id = a.customer_id
JOIN transactions t ON a.account_id  = t.sender_account
WHERE c.risk_score < 600
  AND t.amount > 500000;


-- -----------------------------------------------------
-- Business Question 5: Geographic Hotspot Analysis
--   Which cities record the highest
--   transaction activity?
-- -----------------------------------------------------
SELECT
    city,
    COUNT(*)     AS transaction_count,
    SUM(amount)  AS total_transaction_value
FROM transactions
GROUP BY city
ORDER BY total_transaction_value DESC;


-- =====================================================
-- SECTION 4 — CREATE VIEWS (Continuous Monitoring)
-- =====================================================

-- -----------------------------------------------------
-- View 1 — Suspicious High-Value Transactions
--   Automatically surfaces all transactions
--   exceeding KES 1,000,000
-- -----------------------------------------------------
CREATE VIEW vw_suspicious_transactions AS
SELECT
    transaction_id,
    sender_account,
    recipient_account,
    amount,
    transaction_date,
    city
FROM transactions
WHERE amount > 1000000;


-- -----------------------------------------------------
-- View 2 — Rapid Transfer Activity
--   Identifies accounts with 3 or more
--   transfer transactions
-- -----------------------------------------------------
CREATE VIEW vw_rapid_transfers AS
SELECT
    sender_account,
    COUNT(*) AS transfer_count
FROM transactions
WHERE transaction_type = 'Transfer'
GROUP BY sender_account
HAVING COUNT(*) >= 3;


-- -----------------------------------------------------
-- View 3 — High-Risk Customer Transactions
--   Flags large transactions by customers
--   with risk scores below 600
-- -----------------------------------------------------
CREATE VIEW vw_high_risk_transactions AS
SELECT
    c.customer_name,
    c.risk_score,
    t.amount,
    t.transaction_date,
    t.city
FROM customers c
JOIN accounts a     ON c.customer_id = a.customer_id
JOIN transactions t ON a.account_id  = t.sender_account
WHERE c.risk_score < 600
  AND t.amount > 500000;


-- -----------------------------------------------------
-- View 4 — Transaction Hotspots by City
--   Summarises transaction count and total
--   value by city for geographic monitoring
-- -----------------------------------------------------
CREATE VIEW vw_transaction_hotspots AS
SELECT
    city,
    COUNT(*)    AS transaction_count,
    SUM(amount) AS total_transaction_value
FROM transactions
GROUP BY city;


-- =====================================================
-- SECTION 5 — RUN ALL VIEWS
-- =====================================================

SELECT * FROM vw_suspicious_transactions;
SELECT * FROM vw_rapid_transfers;
SELECT * FROM vw_high_risk_transactions;
SELECT * FROM vw_transaction_hotspots;