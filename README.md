# Audit Log Management System
### (Mini Banking Database)

A SQL-based Audit Log Management System developed using MySQL to automatically track and monitor every change happening inside a banking database. This project demonstrates real-time database auditing using Triggers, Stored Procedures, and analytical SQL queries.

---

## Project Overview

The Audit Log Management System is designed to simulate real-world banking database monitoring. Every INSERT, UPDATE, and DELETE operation is automatically captured in the Audit Log — recording WHO changed it, WHAT was changed, and WHEN it happened — without any manual effort.

The project focuses on:

- Database Design & Relational Modeling
- Trigger-based Automatic Audit Logging
- Stored Procedures for Instant Reports
- SQL Query Optimization
- Banking Data Analytics

This project is ideal for showcasing SQL, database management, and analytics skills for internships, placements, and portfolio projects.

---

## Features

###  Customer Management
- Store customer personal details
- Track city-wise customer distribution
- Maintain customer account relationships

###  Account Management
- Manage Savings and Current accounts
- Track account status (Active / Inactive / Frozen)
- Monitor balance changes automatically

###  Transaction Management
- Record Deposits, Withdrawals, and Transfers
- Track transaction history per account
- Generate monthly transaction reports

###  Audit Log System (Core Feature)
- Auto-log every INSERT, UPDATE, DELETE via Triggers
- Capture old value vs new value for every change
- Record timestamp and user for every action
- Generate instant audit reports via Stored Procedures

---

## Technologies Used

| Technology | Description |
|---|---|
| MySQL | Database Management |
| SQL | Query Language |
| MySQL Workbench | Database Modeling & Query Execution |

---

## Database Tables

| Table Name | Description |
|---|---|
| Customers | Customer personal information |
| Accounts | Bank account details |
| Transactions | All money movement records |
| Audit_Log | Auto-captured log of all DB changes |

---

## Entity Relationship Highlights

- One Customer can have multiple Accounts
- One Account can have multiple Transactions
- Every change in Customers, Accounts, Transactions is auto-logged in Audit_Log
- Audit_Log captures INSERT, UPDATE, DELETE with old and new values

---

## SQL Concepts Used

- Triggers (INSERT / UPDATE / DELETE)
- Stored Procedures
- Window Functions (RANK, PARTITION BY)
- Aggregate Functions (SUM, AVG, COUNT)
- Joins (INNER JOIN, LEFT JOIN)
- Subqueries
- GROUP BY / HAVING
- CASE WHEN

---

## Triggers (5 Triggers)

| Trigger Name | Event | Table |
|---|---|---|
| trg_customer_insert | AFTER INSERT | Customers |
| trg_customer_update | AFTER UPDATE | Customers |
| trg_customer_delete | BEFORE DELETE | Customers |
| trg_account_update | AFTER UPDATE | Accounts |
| trg_transaction_insert | AFTER INSERT | Transactions |

---

## Stored Procedures (3 Procedures)

| Procedure Name | Purpose |
|---|---|
| sp_audit_report | Full audit report for any table |
| sp_audit_by_date | Audit logs between date range |
| sp_action_summary | Summary of all actions by table |

---

## Sample Analytical Queries
Total Bank Balance Across All Accounts
```sql
SELECT SUM(balance) AS total_bank_balance FROM Accounts;
```

 Rank Customers by Total Transaction Amount
```sql
SELECT c.full_name, SUM(t.amount) AS total,
       RANK() OVER (ORDER BY SUM(t.amount) DESC) AS rnk
FROM Customers c
JOIN Accounts a ON c.customer_id = a.customer_id
JOIN Transactions t ON a.account_id = t.account_id
GROUP BY c.full_name;
```

 Monthly Transaction Volume Report
```sql
SELECT MONTH(txn_date) AS month,
       COUNT(*) AS total_txns,
       SUM(amount) AS total_amount
FROM Transactions
GROUP BY MONTH(txn_date)
ORDER BY month;
```

 Most Active Table in Audit Log
```sql
SELECT table_name, COUNT(*) AS changes
FROM Audit_Log
GROUP BY table_name
ORDER BY changes DESC LIMIT 1;
```

---

## Project Objectives

- Automate banking database change tracking
- Eliminate manual audit logging
- Detect unauthorized or suspicious data changes
- Generate instant audit reports for admins
- Support data-driven banking decisions

---

## Learning Outcomes

This project helped in improving:

- Advanced SQL Skills (Triggers, Procedures, Window Functions)
- Database Design & Relational Modeling
- Audit & Compliance System Design
- Banking Domain Knowledge
- Query Optimization

---

## Future Enhancements

- Power BI Dashboard Integration for Audit Reports
- Fraud Detection using ML on Audit Logs
- Web Application Integration
- Real-time Monitoring Alerts
- Role-based Access Control

---

## How to Run the Project

### Step 1: Install MySQL
Install:
- MySQL Server
- MySQL Workbench

### Step 2: Create Database
```sql
CREATE DATABASE ec_chenni;
USE ec_chenni;
```

### Step 3: Import SQL File
Import the provided `AuditLog_Banking_System.sql` file into MySQL Workbench.

### Step 4: Execute Queries
Run the analytical queries and stored procedures to generate reports.

---

## Author

**Elanchetchenni B**  
B.E Computer Science and Engineering – EASA College of Engineering and Technology  
Interested in SQL, Power BI, Data Analytics, and Generative AI  

---

## Conclusion

The Audit Log Management System is a real-time SQL project that demonstrates strong knowledge in database design, trigger-based automation, and banking data analytics. Every change in the banking database is automatically captured and reported — making data fraud and errors impossible to hide. This project is suitable for academic presentations, internships, and data analyst portfolios.
