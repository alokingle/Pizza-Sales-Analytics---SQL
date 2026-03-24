
# 🍕 **Pizza Sales Analytics Using PostgreSQL**  
### *End‑to‑End SQL Portfolio Project*

---

## 📌 **Project Overview**
This project analyzes a multi‑table pizza sales dataset using PostgreSQL.  
It covers the full workflow: **database design, data import, cleaning, exploration, and advanced SQL analytics**.  
The goal is to extract meaningful business insights such as revenue trends, top‑selling pizzas, category performance, and customer ordering patterns.

---

## ⭐ **Project Objectives**
- Build a complete SQL analytics project from scratch  
- Design a normalized relational database schema  
- Import and validate raw CSV files  
- Perform exploratory, intermediate, and advanced SQL analysis  
- Generate actionable insights for business decision‑making  

---

## ⭐ **Dataset Structure**
The project uses four relational tables:

| Table | Description |
|-------|-------------|
| **pizzas** | Pizza ID, type, size, price |
| **pizza_types** | Pizza type name, category, ingredients |
| **orders** | Order ID, date, time |
| **order_details** | Order details, pizza ID, quantity |

---

## 🛠️ **Tech Stack**
- **PostgreSQL**
- **pgAdmin**
- **SQL (CTEs, Window Functions, Joins, Aggregations)**

---

## ⭐ **What I Did (STAR Method)**

### **📌 Situation**
The raw pizza sales dataset consisted of multiple CSV files with no defined schema.  
To analyze sales performance and revenue trends, the data needed to be structured, cleaned, and queried effectively.

### **📌 Task**
Design a relational database, load all data, and write SQL queries (basic → advanced) to uncover insights such as top‑selling pizzas, category performance, cumulative revenue, and ordering patterns.

### **📌 Action**
- Created four normalized PostgreSQL tables with proper **primary keys, foreign keys, and constraints**.  
- Imported all CSV files into PostgreSQL using pgAdmin, resolving encoding and formatting issues.  
- Wrote **15+ SQL queries** covering:
  - Basic SQL (SELECT, DISTINCT, LIKE, BETWEEN)  
  - Intermediate SQL (JOINs, GROUP BY, ORDER BY, aggregations)  
  - Advanced SQL (CTEs, CASE statements, RANK, DENSE_RANK, ROW_NUMBER, cumulative revenue)  
- Performed analysis on:
  - Total orders & daily trends  
  - Revenue and top‑selling pizzas  
  - Category‑wise performance  
  - Hourly ordering patterns  
  - Cumulative revenue over time  
  - Percentage contribution of each pizza type  
  - Top 3 pizzas per category using window functions  

### **📌 Result**
- Delivered a complete, production‑ready SQL analytics project.  
- Identified key insights such as:
  - Best‑selling pizzas  
  - Peak ordering hours  
  - Highest revenue categories  
  - Revenue growth trends  
- Strengthened my analytics portfolio with a real‑world SQL project demonstrating strong skills in **data modeling, analytical SQL, and business insight generation**.

---

## 📊 **Key SQL Concepts Used**
- **INNER JOIN, LEFT JOIN**
- **GROUP BY, ORDER BY**
- **Aggregations (SUM, COUNT, AVG, MAX)**
- **Window Functions (RANK, DENSE_RANK, ROW_NUMBER)**
- **CTEs (Common Table Expressions)**
- **CASE statements**
- **Date & Time functions**

---

## 📁 **Project Files**
- `pizza_sales.sql` – Schema creation  
- `pizza_sales.sql` – All SQL queries (basic → advanced)  
- `pizzas.csv`, `pizza_types.csv`, `orders.csv`, `order_details.csv`  

---

## 🚀 **How to Run This Project**
1. Create a PostgreSQL database  
2. Run the table creation script  
3. Import CSV files using pgAdmin  
4. Execute analysis queries  

---

## 📬 **Connect With Me**
If you’d like to discuss SQL, analytics, or data projects, feel free to reach out!
