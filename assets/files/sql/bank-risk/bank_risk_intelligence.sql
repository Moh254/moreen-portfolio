-- =====================================================
-- PROJECT  : Bank Risk Intelligence System
-- Author   : Moreen Gatwiri
-- Tool     : MySQL
-- Domain   : Credit Risk & Financial Intelligence
-- Description:
--   SQL project analyzing banking risk, loan exposure,
--   collateral coverage, branch default exposure,
--   suspicious transactions, and customer risk monitoring.
-- =====================================================


-- =====================================================
-- SECTION 1 — DATABASE SETUP
-- =====================================================

CREATE DATABASE bank_risk_intelligence;

USE bank_risk_intelligence;


-- =====================================================
-- SECTION 2 — CREATE TABLES
-- =====================================================

CREATE TABLE customers (
    customer_id   INT PRIMARY KEY,
    customer_name VARCHAR(100),
    gender        VARCHAR(10),
    city          VARCHAR(50),
    risk_score    INT,
    signup_date   DATE
);

CREATE TABLE branches (
    branch_id   INT PRIMARY KEY,
    branch_name VARCHAR(100),
    region      VARCHAR(50)
);

CREATE TABLE loans (
    loan_id       INT PRIMARY KEY,
    customer_id   INT,
    branch_id     INT,
    loan_type     VARCHAR(50),
    loan_amount   DECIMAL(15,2),
    interest_rate DECIMAL(5,2),
    loan_status   VARCHAR(20),
    start_date    DATE,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (branch_id)   REFERENCES branches(branch_id)
);

CREATE TABLE collateral (
    collateral_id    INT PRIMARY KEY,
    loan_id          INT,
    collateral_type  VARCHAR(50),
    collateral_value DECIMAL(15,2),
    FOREIGN KEY (loan_id) REFERENCES loans(loan_id)
);

CREATE TABLE transactions (
    transaction_id   INT PRIMARY KEY,
    customer_id      INT,
    transaction_type VARCHAR(50),
    amount           DECIMAL(15,2),
    transaction_date DATETIME,
    city             VARCHAR(50),
    recipient_account VARCHAR(50),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);


-- =====================================================
-- SECTION 3 — INSERT SAMPLE DATA
-- =====================================================

INSERT INTO branches VALUES
(1,  'Westlands',  'Nairobi'),
(2,  'Upper Hill', 'Nairobi'),
(3,  'Mombasa',    'Coast'),
(4,  'Nakuru',     'Rift Valley'),
(5,  'Kisumu',     'Western'),
(6,  'Nyeri',      'Central'),
(7,  'Thika',      'Central'),
(8,  'Eldoret',    'Rift Valley'),
(9,  'Karen',      'Nairobi'),
(10, 'Kitale',     'Western');

INSERT INTO customers VALUES
(101, 'Alice Wanjiku',   'Female', 'Nairobi',  820, '2021-03-12'),
(102, 'Brian Otieno',    'Male',   'Kisumu',   690, '2020-07-21'),
(103, 'Cynthia Njeri',   'Female', 'Nyeri',    740, '2019-11-10'),
(104, 'David Mwangi',    'Male',   'Nakuru',   610, '2022-01-15'),
(105, 'Esther Achieng',  'Female', 'Mombasa',  560, '2021-08-30'),
(106, 'Felix Kiptoo',    'Male',   'Eldoret',  780, '2020-04-11'),
(107, 'Grace Atieno',    'Female', 'Kisumu',   640, '2022-09-01'),
(108, 'Henry Kariuki',   'Male',   'Thika',    720, '2021-06-18'),
(109, 'Irene Naliaka',   'Female', 'Kitale',   590, '2019-12-05'),
(110, 'James Mutiso',    'Male',   'Karen',    845, '2020-02-14'),
(111, 'Kevin Ouma',      'Male',   'Mombasa',  530, '2021-10-03'),
(112, 'Linda Chebet',    'Female', 'Eldoret',  760, '2022-03-29'),
(113, 'Mercy Wairimu',   'Female', 'Nairobi',  805, '2020-05-20'),
(114, 'Nelson Kibet',    'Male',   'Kitale',   675, '2021-01-09'),
(115, 'Olive Anyango',   'Female', 'Kisumu',   615, '2022-07-07');

INSERT INTO loans VALUES
(1001, 101, 1,  'Mortgage',      8000000,  11.50, 'Performing', '2023-01-15'),
(1002, 102, 5,  'SME',           2500000,  17.00, 'Watchlist',  '2022-09-20'),
(1003, 103, 6,  'Personal',       500000,  22.00, 'Performing', '2023-06-01'),
(1004, 104, 4,  'Asset Finance', 1800000,  15.00, 'Default',    '2021-12-11'),
(1005, 105, 3,  'SME',           3200000,  18.50, 'Default',    '2022-03-18'),
(1006, 106, 8,  'Mortgage',     12000000,  10.80, 'Performing', '2021-05-14'),
(1007, 107, 5,  'Personal',       350000,  24.00, 'Watchlist',  '2023-02-08'),
(1008, 108, 7,  'Asset Finance', 2200000,  14.50, 'Performing', '2022-11-30'),
(1009, 109, 10, 'SME',           4100000,  19.00, 'Default',    '2021-08-22'),
(1010, 110, 9,  'Mortgage',     15000000,  10.20, 'Performing', '2020-10-10'),
(1011, 111, 3,  'Personal',       600000,  25.00, 'Default',    '2022-01-05'),
(1012, 112, 8,  'Mortgage',      9500000,  11.00, 'Performing', '2021-09-17'),
(1013, 113, 2,  'SME',           5000000,  16.50, 'Performing', '2023-04-12'),
(1014, 114, 10, 'Asset Finance', 2600000,  15.20, 'Watchlist',  '2022-06-25'),
(1015, 115, 5,  'Personal',       450000,  23.50, 'Default',    '2023-03-03');

INSERT INTO collateral VALUES
(1,  1001, 'Property',        10000000),
(2,  1002, 'Business Assets',  1800000),
(3,  1003, 'None',                   0),
(4,  1004, 'Vehicle',          1200000),
(5,  1005, 'Business Assets',  2500000),
(6,  1006, 'Property',        14000000),
(7,  1007, 'None',                   0),
(8,  1008, 'Vehicle',          2600000),
(9,  1009, 'Business Assets',  3000000),
(10, 1010, 'Property',        18000000),
(11, 1011, 'None',                   0),
(12, 1012, 'Property',        11000000),
(13, 1013, 'Business Assets',  5500000),
(14, 1014, 'Vehicle',          2000000),
(15, 1015, 'None',                   0);


-- =====================================================
-- SECTION 4 — ANALYSIS QUERIES
-- =====================================================

-- -----------------------------------------------------
-- 6.1 Customer Loan Exposure
--     Business Question: Which customers have the
--     highest total loan exposure?
-- -----------------------------------------------------
SELECT
    c.customer_id,
    c.customer_name,
    SUM(l.loan_amount) AS total_loan_exposure
FROM customers c
JOIN loans l ON c.customer_id = l.customer_id
GROUP BY c.customer_id, c.customer_name
ORDER BY total_loan_exposure DESC;


-- -----------------------------------------------------
-- 6.2 Under-Collateralised Loans
--     Business Question: Which loans are not
--     adequately secured by collateral?
-- -----------------------------------------------------
SELECT
    l.loan_id,
    c.customer_name,
    l.loan_type,
    l.loan_amount,
    col.collateral_value,
    ROUND(col.collateral_value / l.loan_amount, 2) AS collateral_coverage_ratio
FROM loans l
JOIN customers c   ON l.customer_id = c.customer_id
JOIN collateral col ON l.loan_id = col.loan_id
WHERE col.collateral_value < l.loan_amount
ORDER BY collateral_coverage_ratio ASC;


-- -----------------------------------------------------
-- 6.3 Branch Default Exposure
--     Business Question: Which branches carry the
--     highest default loan exposure?
-- -----------------------------------------------------
SELECT
    b.branch_name,
    SUM(l.loan_amount) AS default_exposure
FROM branches b
JOIN loans l ON b.branch_id = l.branch_id
WHERE l.loan_status = 'Default'
GROUP BY b.branch_name
ORDER BY default_exposure DESC;


-- -----------------------------------------------------
-- 6.4 Suspicious Transaction Monitoring
--     Business Question: Which customers show
--     suspicious high-value transaction behaviour?
-- -----------------------------------------------------
SELECT
    t.transaction_id,
    c.customer_name,
    t.transaction_type,
    t.amount,
    t.transaction_date,
    t.city
FROM transactions t
JOIN customers c ON t.customer_id = c.customer_id
WHERE t.amount >= 1000000
ORDER BY t.amount DESC;


-- -----------------------------------------------------
-- 6.5 Customer Risk Flagging
--     Business Question: Which customers should be
--     flagged for review based on multiple risk factors?
-- -----------------------------------------------------
SELECT
    c.customer_id,
    c.customer_name,
    c.risk_score,
    l.loan_status,
    l.loan_amount,
    col.collateral_value,
    CASE
        WHEN c.risk_score < 600
          OR l.loan_status IN ('Default', 'Watchlist')
          OR col.collateral_value < l.loan_amount
        THEN 'Flag for Review'
        ELSE 'Normal'
    END AS review_flag
FROM customers c
JOIN loans l       ON c.customer_id = l.customer_id
JOIN collateral col ON l.loan_id = col.loan_id
ORDER BY review_flag DESC, c.risk_score ASC;


-- =====================================================
-- SECTION 5 — CREATE VIEWS (Continuous Monitoring)
-- =====================================================

-- -----------------------------------------------------
-- View 7.1 — Customer Loan Exposure
-- -----------------------------------------------------
CREATE VIEW vw_customer_loan_exposure AS
SELECT
    c.customer_id,
    c.customer_name,
    SUM(l.loan_amount)  AS total_loan_exposure,
    COUNT(l.loan_id)    AS number_of_loans
FROM customers c
JOIN loans l ON c.customer_id = l.customer_id
GROUP BY c.customer_id, c.customer_name;


-- -----------------------------------------------------
-- View 7.2 — Branch Risk Exposure
-- -----------------------------------------------------
CREATE VIEW vw_branch_risk_exposure AS
SELECT
    b.branch_name,
    b.region,
    SUM(l.loan_amount) AS total_branch_exposure,
    COUNT(l.loan_id)   AS total_loans
FROM branches b
JOIN loans l ON b.branch_id = l.branch_id
GROUP BY b.branch_name, b.region;


-- -----------------------------------------------------
-- View 7.3 — Collateral Coverage
-- -----------------------------------------------------
CREATE VIEW vw_collateral_coverage AS
SELECT
    l.loan_id,
    c.customer_name,
    l.loan_amount,
    col.collateral_value,
    ROUND(col.collateral_value / l.loan_amount, 2) AS coverage_ratio
FROM loans l
JOIN customers c   ON l.customer_id = c.customer_id
JOIN collateral col ON l.loan_id = col.loan_id;


-- -----------------------------------------------------
-- View 7.4 — High Value Transactions
-- -----------------------------------------------------
CREATE VIEW vw_high_value_transactions AS
SELECT
    t.transaction_id,
    c.customer_name,
    t.transaction_type,
    t.amount,
    t.transaction_date,
    t.city
FROM transactions t
JOIN customers c ON t.customer_id = c.customer_id
WHERE t.amount >= 1000000;


-- -----------------------------------------------------
-- View 7.5 — Customer Risk Monitoring
-- -----------------------------------------------------
CREATE VIEW vw_customer_risk_monitoring AS
SELECT
    c.customer_id,
    c.customer_name,
    c.risk_score,
    l.loan_status,
    l.loan_amount,
    col.collateral_value,
    CASE
        WHEN c.risk_score < 600
          OR l.loan_status IN ('Default', 'Watchlist')
          OR col.collateral_value < l.loan_amount
        THEN 'Flag for Review'
        ELSE 'Normal'
    END AS review_flag
FROM customers c
JOIN loans l       ON c.customer_id = l.customer_id
JOIN collateral col ON l.loan_id = col.loan_id;


-- =====================================================
-- SECTION 6 — RUN ALL VIEWS
-- =====================================================

SELECT * FROM vw_customer_loan_exposure;
SELECT * FROM vw_branch_risk_exposure;
SELECT * FROM vw_collateral_coverage;
SELECT * FROM vw_high_value_transactions;
SELECT * FROM vw_customer_risk_monitoring;