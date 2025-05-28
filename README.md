# 📊 Customer Segmentation & Churn Analysis using RFM 

A complete end-to-end data analytics project using **Python**, **SQL**, **Power BI**, and **RFM segmentation** to identify customer purchase behavior, churn risk, and actionable business insights from Brazilian e-commerce data.

![Customer Churn Dashboard 1](Customer%20Churn%20Dashboard-1.png)
![Customer Churn Dashboard 2](Customer%20Churn%20Dashboard-2.png)

---

## 🧩 Project Overview

This project analyzes customer order behavior using **Recency, Frequency, and Monetary (RFM)** segmentation. Leveraging data from the **Olist E-commerce dataset**, a 2-page interactive Power BI dashboard was created to help identify:

- 🎯 High-value vs low-value customers  
- 📉 Churn risk segmentation  
- 🧠 Customer insights for retention strategies  

---

## 📁 Dataset Used

**Source:** [Kaggle - Brazilian E-Commerce Public Dataset](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce)

**Cleaned Files Used:**
- `customers.csv`
- `orders.csv`
- `order_items.csv`
- `payments.csv`
- `products.csv`

---

## 🔧 Tools & Technologies

-**Python:** Data merging, cleaning, null handling
- **SQL (MySQL):** Data cleaning, transformation, and RFM segmentation logic  
- **Power BI:** Data modeling, DAX measures, and dashboard creation  
- **Excel/CSV:** Intermediate exploration and data export  

---

## 🧠 Business Questions Solved

- Who are our most loyal and high-value customers?  
- Which customers are at high risk of churn?  
- What is the average customer lifetime value?  
- What are the top-performing cities and states?  
- How can we optimize customer retention strategies?  

---

## ⚙️ Key Steps Performed

### 🔹 Data Cleaning & Preparation
- Removed duplicates and handled missing values  
- Parsed dates and formatted currencies  
- Joined datasets to build a unified view of customer orders 

## 📈 RFM Segmentation Logic (SQL)

```sql
CASE
    WHEN recency <= 30 THEN 'Recent'
    WHEN recency BETWEEN 31 AND 90 THEN 'Warm'
    ELSE 'Inactive'
END AS recency_segment,

CASE
    WHEN frequency >= 5 THEN 'Frequent'
    WHEN frequency BETWEEN 2 AND 4 THEN 'Occasional'
    ELSE 'Rare'
END AS frequency_segment,

CASE
    WHEN monetary >= 1000 THEN 'High Spender'
    WHEN monetary BETWEEN 500 AND 999 THEN 'Mid Spender'
    ELSE 'Low Spender'
END AS monetary_segment

```

---

## 🔹 DAX Measures in Power BI

- **Total Revenue**  
- **Customer Count**  
- **Average Order Value (AOV)**  
- **Average Recency, Frequency, and Monetary**  
- **Churned vs Active Customers (with %)**  
- **Customer Lifetime Value (CLV)**  
- **Top 5 States by Revenue**  
- **Top 5 Cities by Order Count**

---

## 🔹 Dashboard Layout

### 📄 Page 1: Executive Overview

- **Sidebar Filters:** Region, City, Date Range, Segment  
- **KPIs:** Revenue, Customer Count, CLV, AOV, Churn %  
- **Visuals:** Pie charts, bar graphs, churn heatmaps  

### 📄 Page 2: Segmentation Deep Dive

- **Matrix:** RFM segments vs churn risk  
- **Donuts:** Customer types by value  
- **Bar Charts:** Revenue per state, orders per city  
- **Slicers:** Drilldowns by geography  

---

## 📌 Key Insights

💰 **1.3% of customers are high-value but contribute over 20% of total revenue**  
⚠️ **Over 70% of customers fall under low-value or churned risk segments**  
🏙️ **States like SP, RJ, MG dominate both in revenue and order count**  
📉 **Customers inactive for >90 days are 4x more likely to churn**  
🎯 **Retargeting “Warm & Mid Spenders” could boost retention by 15%**

---

## 📤 Output

- 📁 `final_rfm_data.csv` – Cleaned and segmented customer data  
- 📊 `RFM_Segmentation_Dashboard.pbix` – Interactive customer segmentation report  

---

## 📚 How to Use

1. Import cleaned `.csv` files into MySQL and create the `rfm_segmented` view  
2. Export final table to `.csv` using `SELECT INTO OUTFILE`  
3. Load `.csv` into Power BI and create the data model  
4. Add DAX measures and build the dashboard as per layout  


---

## 📈 Project Impact

> “This dashboard provides business users with a clear view of customer health, allowing targeted retention and marketing efforts to boost long-term revenue.”

