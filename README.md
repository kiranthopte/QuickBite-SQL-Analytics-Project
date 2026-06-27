# 🍔 QuickBite SQL Analytics Project

## 📌 Project Overview

This project demonstrates how SQL can be used to solve real-world business problems in a food delivery platform.

Using the **QuickBite** dataset, I solved **15 advanced analytics challenges** covering customer analytics, restaurant performance, revenue analysis, retention, segmentation, and business intelligence reporting.

The objective was not only to write correct SQL queries but also to build **production-style, optimized solutions** using indexing and modern SQL techniques.

---

# 📊 Dataset

The project uses a relational food delivery database consisting of multiple dimension and fact tables.

### Main Tables

* `fact_orders`
* `dim_customer`
* `dim_restaurant`
* `dim_menu`
* `dim_date`

The dataset simulates a real food delivery platform with thousands of orders across multiple restaurants and cities.

---

# 🚀 Business Problems Solved

## Restaurant Analytics

* Top 3 restaurants by revenue in every city during the last 6 months
* Restaurants with continuously increasing revenue for the last three months
* Restaurants having the highest cancellation percentage
* Rolling 30-day average revenue for every restaurant
* Highest-selling menu item for every restaurant
* Top 20 restaurants in every city with the highest weighted average discount

---

## Customer Analytics

* Top 10 customers contributing the highest revenue in every acquisition channel
* Customers who ordered from at least five different cuisine types
* Customers who have not ordered for the last 30 days
* Customers inactive for more than two months
* Customers whose Average Order Value is above their city average

---

## Advanced Business Analytics

* Monthly Cohort Retention Analysis
* Customer RFM (Recency, Frequency, Monetary) Segmentation
* Pareto Analysis (Customers contributing the first 80% of total revenue)

---

# 🛠 SQL Concepts Covered

## Window Functions

* ROW_NUMBER()
* RANK()
* DENSE_RANK()
* LAG()
* LEAD()
* SUM() OVER()
* AVG() OVER()

---

## Common Table Expressions (CTEs)

Used extensively for breaking complex business logic into readable and reusable query blocks.

---

## Aggregate Functions

* SUM()
* AVG()
* COUNT()
* MAX()
* MIN()

---

## Date & Time Functions

* DATE_FORMAT()
* TIMESTAMPDIFF()
* DATEDIFF()
* STR_TO_DATE()
* CURDATE()

---

## SQL Techniques

* Conditional Aggregation
* CASE Statements
* Multi-table JOINs
* Correlated Subqueries
* Nested CTEs
* Rolling Window Calculations
* Ranking Functions
* Cohort Analysis
* RFM Analysis
* Pareto (80/20) Analysis

---

# ⚡ Query Optimization

Performance was an important focus throughout this project.

Optimization techniques include:

* Appropriate indexing on frequently filtered and joined columns
* Efficient JOIN strategies
* Window function optimization
* Minimizing unnecessary table scans
* Using CTEs to improve readability while maintaining performance

---

# 📚 Key Learnings

This project strengthened my understanding of:

* Writing production-quality SQL
* Translating business requirements into SQL solutions
* Customer and restaurant analytics
* Revenue analysis
* Retention analysis
* Performance optimization
* SQL best practices

---

# 🎯 Skills Demonstrated

* MySQL
* SQL Query Optimization
* Database Design
* Business Analytics
* Customer Segmentation
* Revenue Analytics
* Window Functions
* Cohort Analysis
* RFM Analysis
* Indexing
* Data Analysis

---

# 📈 Future Enhancements

* Build an interactive Power BI dashboard
* Add stored procedures and views
* Implement SQL performance benchmarking
* Expand the dataset with real-time streaming scenarios
* Add advanced interview questions and solutions

---

## ⭐ If you found this project useful, consider giving it a star!

Feedback, suggestions, and contributions are always welcome.
