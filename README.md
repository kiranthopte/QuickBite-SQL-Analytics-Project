# 🍔 QuickBite SQL Analytics Project

> **Advanced MySQL Business Analytics | Production-Style SQL | Query Optimization | FAANG-Level SQL Challenges**


## 📌 Project Overview

This project demonstrates how **SQL can solve real-world business problems** in a food delivery platform.

Using the **QuickBite** dataset, I solved **15 advanced business analytics case studies** while focusing on:

- Writing production-quality SQL
- Query optimization
- Window Functions
- Business KPIs
- Customer Analytics
- Revenue Analytics
- Performance tuning using Indexes

The project is designed to simulate the kind of SQL problems solved by **Data Analysts, Business Analysts, Analytics Engineers, and Data Engineers**.

---

# 📂 Database Schema

The project contains the following tables:

```
dim_customer
dim_restaurant
dim_delivery_partner
dim_menu_item

fact_orders
fact_order_items
fact_ratings
fact_delivery_performance
```

---

# 🚀 Business Problems Solved

## 🍽 Restaurant Analytics

- Top 3 restaurants by revenue in every city (last 6 months)
- Restaurants with continuously increasing monthly revenue
- Restaurants with the highest cancellation percentage
- Rolling 30-Day Average Revenue
- Highest-selling menu item for every restaurant
- Top 20 restaurants with the highest weighted discount

---

## 👥 Customer Analytics

- Top 10 customers by revenue in every acquisition channel
- Customers ordering from at least 5 cuisine types
- Customers inactive for the last 30 days
- Customers inactive for more than 2 months
- Customers whose Average Order Value exceeds their city average

---

## 📈 Advanced Business Analytics

- Monthly Cohort Retention Analysis
- Customer RFM Segmentation
- Pareto Analysis (80/20 Rule)

---

# 🛠 SQL Concepts Covered

## Window Functions

- ROW_NUMBER()
- RANK()
- DENSE_RANK()
- LAG()
- LEAD()
- SUM() OVER()
- AVG() OVER()
- NTILE()

---

## Common Table Expressions (CTEs)

- Single CTE
- Multiple CTEs
- Nested CTEs

---

## Joins

- INNER JOIN
- LEFT JOIN
- Multiple Table JOINs

---

## Aggregations

- SUM()
- AVG()
- COUNT()
- MAX()
- MIN()

---

## Date Functions

- DATE()
- DATE_FORMAT()
- STR_TO_DATE()
- DATEDIFF()
- TIMESTAMPDIFF()
- DATE_SUB()

---

## SQL Techniques

- Window Functions
- Ranking
- Running Totals
- Rolling Windows
- Conditional Aggregation
- CASE Statements
- Correlated Subqueries
- Business KPIs
- Revenue Analysis
- Customer Segmentation
- Cohort Analysis
- Pareto Analysis
- RFM Analysis

---

# ⚡ Query Optimization

Performance optimization was a major focus throughout this project.

## Indexes Created

```sql
CREATE INDEX idx_orders_customer_date
ON fact_orders(customer_id, order_timestamp);

CREATE INDEX idx_orders_restaurant_date
ON fact_orders(restaurant_id, order_timestamp);

CREATE INDEX idx_orderitems_order
ON fact_order_items(order_id);

CREATE INDEX idx_ratings_restaurant
ON fact_ratings(restaurant_id);

CREATE INDEX idx_delivery_order
ON fact_delivery_performance(order_id);

CREATE INDEX idx_orders_cancelled_date
ON fact_orders(is_cancelled, order_timestamp);
```

### Optimization Techniques

- Composite Indexes
- Efficient JOIN strategies
- Reduced table scans
- Optimized filtering
- Window Function optimization
- CTE-based query structuring

---

# 📊 Skills Demonstrated

- Advanced SQL
- MySQL 8.0
- Query Optimization
- Window Functions
- Customer Analytics
- Revenue Analytics
- Restaurant Analytics
- Cohort Analysis
- RFM Analysis
- Pareto Analysis
- Business Intelligence
- Performance Tuning

---

# 📚 Key Learnings

Through this project I learned how to:

- Convert business requirements into SQL queries
- Optimize complex SQL queries
- Analyze customer behavior
- Build business KPIs
- Use Window Functions effectively
- Perform advanced analytical calculations
- Write production-ready SQL code

---

# 🏗 Repository Structure

```
QuickBite-SQL-Analytics/
│
├── Dataset/
│   ├── customers.csv
│   ├── restaurants.csv
│   ├── orders.csv
│   ├── order_items.csv
│   └── ...
│
├── SQL/
│   ├── Database_Setup.sql
│   ├── Indexes.sql
│   ├── Restaurant_Analytics.sql
│   ├── Customer_Analytics.sql
│   ├── Cohort_Analysis.sql
│   ├── RFM_Analysis.sql
│   └── Query_Optimization.sql
│
├── README.md
│
└── LICENSE
```

---

# 🎯 Future Improvements

- ✅ Power BI Dashboard
- ✅ Interactive KPI Dashboard
- ✅ Stored Procedures
- ✅ Views
- ✅ Advanced SQL Interview Questions
- ✅ Query Execution Plan Analysis

---

# ⭐ Connect With Me

If you found this project useful:

- ⭐ Star this repository
- 🍴 Fork it
- 💡 Share feedback
- 🤝 Connect with me on LinkedIn

---

## 💻 Author

**Kiran Thopte**

*Aspiring Data Analyst | SQL | Power BI | Excel | Python | Business Analytics*

---

### ⭐ If this project helped you learn advanced SQL, don't forget to Star the repository!
