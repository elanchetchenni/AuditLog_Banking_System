-- ============================================================
-- PROJECT  : AUDIT LOG MANAGEMENT SYSTEM
--            (Mini Banking Database)
-- AUTHOR   : Elanchetchenni B
-- COLLEGE  : EASA College of Engineering and Technology
-- BATCH    : 2026
-- DATABASE : MySQL
-- ============================================================

CREATE DATABASE ec_chenni;
USE ec_chenni;

CREATE TABLE Customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name   VARCHAR(100) NOT NULL,
    email       VARCHAR(100) UNIQUE NOT NULL,
    phone       VARCHAR(15),
    city        VARCHAR(50),
    created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Accounts (
    account_id   INT AUTO_INCREMENT PRIMARY KEY,
    customer_id  INT,
    account_type ENUM('Savings', 'Current') DEFAULT 'Savings',
    balance      DECIMAL(12,2) DEFAULT 0.00,
    status       ENUM('Active', 'Inactive', 'Frozen') DEFAULT 'Active',
    created_at   TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

CREATE TABLE Transactions (
    txn_id     INT AUTO_INCREMENT PRIMARY KEY,
    account_id INT,
    txn_type   ENUM('Deposit', 'Withdrawal', 'Transfer') NOT NULL,
    amount     DECIMAL(12,2) NOT NULL,
    txn_date   TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    remarks    VARCHAR(255),
    FOREIGN KEY (account_id) REFERENCES Accounts(account_id)
);

CREATE TABLE Audit_Log (
    log_id      INT AUTO_INCREMENT PRIMARY KEY,
    table_name  VARCHAR(50),
    action_type ENUM('INSERT', 'UPDATE', 'DELETE'),
    record_id   INT,
    changed_by  VARCHAR(100),
    old_value   TEXT,
    new_value   TEXT,
    changed_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO Customers (full_name, email, phone, city) VALUES
('Elan B',     'elan@gmail.com',    '9876543210', 'Chennai'),
('Ravi Kumar', 'ravi@gmail.com',    '9123456789', 'Bangalore'),
('Priya S',    'priya@gmail.com',   '9988776655', 'Chennai'),
('Arjun M',    'arjun@gmail.com',   '9871234560', 'Coimbatore'),
('Deepa R',    'deepa@gmail.com',   '9765432100', 'Madurai'),
('Karthik V',  'karthik@gmail.com', '9654321009', 'Chennai'),
('Sneha T',    'sneha@gmail.com',   '9543210098', 'Trichy'),
('Vikram N',   'vikram@gmail.com',  '9432100987', 'Bangalore'),
('Anita P',    'anita@gmail.com',   '9321009876', 'Salem'),
('Suresh L',   'suresh@gmail.com',  '9210098765', 'Chennai');

INSERT INTO Accounts (customer_id, account_type, balance, status) VALUES
(1,  'Savings', 15000.00, 'Active'),
(2,  'Current', 50000.00, 'Active'),
(3,  'Savings',  8000.00, 'Active'),
(4,  'Savings', 25000.00, 'Active'),
(5,  'Current', 75000.00, 'Active'),
(6,  'Savings',  3000.00, 'Frozen'),
(7,  'Current', 60000.00, 'Active'),
(8,  'Savings', 12000.00, 'Inactive'),
(9,  'Savings', 45000.00, 'Active'),
(10, 'Current', 90000.00, 'Active'),
(1,  'Current', 30000.00, 'Active'),
(3,  'Current', 20000.00, 'Active');

INSERT INTO Transactions (account_id, txn_type, amount, remarks) VALUES
(1,  'Deposit',    5000.00, 'Salary credit'),
(1,  'Withdrawal', 2000.00, 'ATM withdrawal'),
(2,  'Deposit',   10000.00, 'Business income'),
(2,  'Transfer',   5000.00, 'UPI transfer'),
(3,  'Deposit',    3000.00, 'Salary credit'),
(4,  'Withdrawal', 1000.00, 'ATM withdrawal'),
(4,  'Deposit',    8000.00, 'Freelance payment'),
(5,  'Transfer',  15000.00, 'NEFT transfer'),
(6,  'Deposit',    2000.00, 'Cash deposit'),
(7,  'Withdrawal', 5000.00, 'ATM withdrawal'),
(7,  'Deposit',   20000.00, 'Salary credit'),
(8,  'Transfer',   3000.00, 'UPI transfer'),
(9,  'Deposit',   12000.00, 'Business income'),
(9,  'Withdrawal', 4000.00, 'ATM withdrawal'),
(10, 'Deposit',   25000.00, 'Salary credit'),
(10, 'Transfer',  10000.00, 'NEFT transfer'),
(1,  'Deposit',    7000.00, 'Bonus credit'),
(2,  'Withdrawal', 8000.00, 'ATM withdrawal'),
(3,  'Deposit',    5000.00, 'Cash deposit'),
(4,  'Transfer',   2000.00, 'UPI transfer');


DELIMITER $$
CREATE TRIGGER trg_customer_insert
AFTER INSERT ON Customers
FOR EACH ROW
BEGIN
    INSERT INTO Audit_Log (table_name, action_type, record_id, changed_by, new_value)
    VALUES ('Customers', 'INSERT', NEW.customer_id, USER(),
            CONCAT('Name: ', NEW.full_name, ' | Email: ', NEW.email, ' | City: ', NEW.city));
END$$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER trg_customer_update
AFTER UPDATE ON Customers
FOR EACH ROW
BEGIN
    INSERT INTO Audit_Log (table_name, action_type, record_id, changed_by, old_value, new_value)
    VALUES ('Customers', 'UPDATE', OLD.customer_id, USER(),
            CONCAT('Name: ', OLD.full_name, ' | Phone: ', OLD.phone),
            CONCAT('Name: ', NEW.full_name, ' | Phone: ', NEW.phone));
END$$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER trg_customer_delete
BEFORE DELETE ON Customers
FOR EACH ROW
BEGIN
    INSERT INTO Audit_Log (table_name, action_type, record_id, changed_by, old_value)
    VALUES ('Customers', 'DELETE', OLD.customer_id, USER(),
            CONCAT('Name: ', OLD.full_name, ' | Email: ', OLD.email));
END$$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER trg_account_update
AFTER UPDATE ON Accounts
FOR EACH ROW
BEGIN
    INSERT INTO Audit_Log (table_name, action_type, record_id, changed_by, old_value, new_value)
    VALUES ('Accounts', 'UPDATE', OLD.account_id, USER(),
            CONCAT('Balance: ', OLD.balance, ' | Status: ', OLD.status),
            CONCAT('Balance: ', NEW.balance, ' | Status: ', NEW.status));
END$$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER trg_transaction_insert
AFTER INSERT ON Transactions
FOR EACH ROW
BEGIN
    INSERT INTO Audit_Log (table_name, action_type, record_id, changed_by, new_value)
    VALUES ('Transactions', 'INSERT', NEW.txn_id, USER(),
            CONCAT('Type: ', NEW.txn_type, ' | Amount: ', NEW.amount, ' | Remarks: ', NEW.remarks));
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE sp_audit_report(IN tbl_name VARCHAR(50))
BEGIN
    SELECT log_id, action_type, record_id,
           old_value, new_value, changed_by, changed_at
    FROM Audit_Log
    WHERE table_name = tbl_name
    ORDER BY changed_at DESC;
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE sp_audit_by_date(IN from_date DATE, IN to_date DATE)
BEGIN
    SELECT * FROM Audit_Log
    WHERE DATE(changed_at) BETWEEN from_date AND to_date
    ORDER BY changed_at DESC;
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE sp_action_summary()
BEGIN
    SELECT table_name, action_type,
           COUNT(*) AS total_actions
    FROM Audit_Log
    GROUP BY table_name, action_type
    ORDER BY table_name;
END$$
DELIMITER ;


-- 1. Retrieve all customers
SELECT * FROM Customers;

-- 2. Find all active accounts
SELECT * FROM Accounts WHERE status = 'Active';

-- 3. Display all deposit transactions
SELECT * FROM Transactions WHERE txn_type = 'Deposit';

-- 4. Find all customers from Chennai
SELECT * FROM Customers WHERE city = 'Chennai';

-- 5. Count total accounts per customer
SELECT customer_id, COUNT(*) AS total_accounts
FROM Accounts GROUP BY customer_id;

-- 6. Find accounts with balance above 10000
SELECT * FROM Accounts WHERE balance > 10000;

-- 7. Display top 10 highest transactions
SELECT * FROM Transactions ORDER BY amount DESC LIMIT 10;

-- 8. Find total transactions per account
SELECT account_id, COUNT(*) AS txn_count
FROM Transactions GROUP BY account_id;

-- 9. Retrieve all frozen accounts
SELECT * FROM Accounts WHERE status = 'Frozen';

-- 10. Find all DELETE actions in audit log
SELECT * FROM Audit_Log WHERE action_type = 'DELETE';

-- 11. Count audit log entries per table
SELECT table_name, COUNT(*) AS total_logs
FROM Audit_Log GROUP BY table_name;

-- 12. Find all UPDATE logs in audit
SELECT * FROM Audit_Log WHERE action_type = 'UPDATE';

-- 13. Display latest 20 audit records
SELECT * FROM Audit_Log ORDER BY changed_at DESC LIMIT 20;

-- 14. Find total amount deposited
SELECT SUM(amount) AS total_deposited
FROM Transactions WHERE txn_type = 'Deposit';

-- 15. Retrieve all transactions made today
SELECT * FROM Transactions WHERE DATE(txn_date) = CURDATE();

-- 16. Find average transaction amount
SELECT AVG(amount) AS avg_amount FROM Transactions;

-- 17. Retrieve all INSERT actions from audit log
SELECT * FROM Audit_Log WHERE action_type = 'INSERT';

-- 18. Find customers with more than 1 account
SELECT customer_id, COUNT(*) AS acc_count
FROM Accounts GROUP BY customer_id HAVING acc_count > 1;

-- 19. Display total balance across all accounts
SELECT SUM(balance) AS total_bank_balance FROM Accounts;

-- 20. Find withdrawal transactions above 5000
SELECT * FROM Transactions
WHERE txn_type = 'Withdrawal' AND amount > 5000;

-- ============================================================
-- SECTION 6: INTERMEDIATE LEVEL QUERIES (15)
-- ============================================================

-- 1. Top 5 accounts with highest total transaction amount
SELECT account_id, SUM(amount) AS total_txn
FROM Transactions
GROUP BY account_id ORDER BY total_txn DESC LIMIT 5;

-- 2. Customers who have both Savings and Current accounts
SELECT customer_id FROM Accounts
GROUP BY customer_id
HAVING COUNT(DISTINCT account_type) = 2;

-- 3. Second highest transaction amount
SELECT MAX(amount) AS second_highest FROM Transactions
WHERE amount < (SELECT MAX(amount) FROM Transactions);

-- 4. Monthly transaction volume report
SELECT MONTH(txn_date) AS month,
       COUNT(*) AS total_txns,
       SUM(amount) AS total_amount
FROM Transactions
GROUP BY MONTH(txn_date) ORDER BY month;

-- 5. Accounts that were never transacted
SELECT a.account_id, c.full_name
FROM Accounts a
JOIN Customers c ON a.customer_id = c.customer_id
LEFT JOIN Transactions t ON a.account_id = t.account_id
WHERE t.txn_id IS NULL;

-- 6. Rank customers by total transaction amount
SELECT c.full_name, SUM(t.amount) AS total,
       RANK() OVER (ORDER BY SUM(t.amount) DESC) AS rnk
FROM Customers c
JOIN Accounts a ON c.customer_id = a.customer_id
JOIN Transactions t ON a.account_id = t.account_id
GROUP BY c.full_name;

-- 7. Accounts with more than 3 transactions in a single day
SELECT account_id, DATE(txn_date) AS txn_day,
       COUNT(*) AS txn_count
FROM Transactions
GROUP BY account_id, DATE(txn_date)
HAVING txn_count > 3;

-- 8. Percentage of each transaction type
SELECT txn_type, COUNT(*) AS total,
       ROUND(COUNT(*) * 100.0 /
       (SELECT COUNT(*) FROM Transactions), 2) AS percentage
FROM Transactions GROUP BY txn_type;

-- 9. Most active table in audit log
SELECT table_name, COUNT(*) AS changes
FROM Audit_Log
GROUP BY table_name ORDER BY changes DESC LIMIT 1;

-- 10. Accounts whose balance was updated more than twice
SELECT record_id AS account_id, COUNT(*) AS balance_updates
FROM Audit_Log
WHERE table_name = 'Accounts' AND action_type = 'UPDATE'
GROUP BY record_id HAVING balance_updates > 2;

-- 11. Running balance per account
SELECT account_id, txn_type, amount,
       SUM(CASE WHEN txn_type = 'Deposit' THEN amount
                ELSE -amount END)
       OVER (PARTITION BY account_id
             ORDER BY txn_date) AS running_balance
FROM Transactions;

-- 12. Find duplicate customer emails
SELECT email, COUNT(*) AS cnt
FROM Customers GROUP BY email HAVING cnt > 1;

-- 13. Audit log entries per day
SELECT DATE(changed_at) AS log_date,
       COUNT(*) AS total_changes
FROM Audit_Log
GROUP BY DATE(changed_at) ORDER BY log_date DESC;

-- 14. City wise total account balance
SELECT c.city, SUM(a.balance) AS total_balance
FROM Customers c
JOIN Accounts a ON c.customer_id = a.customer_id
GROUP BY c.city ORDER BY total_balance DESC;

-- 15. Average transaction amount per account type
SELECT a.account_type,
       ROUND(AVG(t.amount), 2) AS avg_txn_amount
FROM Accounts a
JOIN Transactions t ON a.account_id = t.account_id
GROUP BY a.account_type;

-- ============================================================
-- SECTION 7: TEST QUERIES
-- ============================================================

-- Test INSERT trigger
INSERT INTO Customers (full_name, email, phone, city)
VALUES ('Test User', 'test@gmail.com', '9000000001', 'Chennai');

-- Test UPDATE trigger
UPDATE Customers SET phone = '9111111111'
WHERE full_name = 'Test User';

-- Test DELETE trigger
DELETE FROM Customers WHERE full_name = 'Test User';

-- Test account balance UPDATE trigger
UPDATE Accounts SET balance = 99999 WHERE account_id = 1;

-- Verify audit log captured all actions
SELECT * FROM Audit_Log ORDER BY changed_at DESC;

-- Call stored procedures
CALL sp_audit_report('Customers');
CALL sp_audit_by_date('2024-01-01', '2026-12-31');
CALL sp_action_summary();

-- END OF PROJECT
