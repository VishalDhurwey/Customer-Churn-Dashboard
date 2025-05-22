# 🧠 Customer Segmentation & Churn Analysis using RFM | Power BI + MySQL + Python

This project helps an e-commerce business identify **high-value customers**, **churn risks**, and **spending behavior** using RFM (Recency, Frequency, Monetary) segmentation, with a fully interactive **Power BI Dashboard** powered by a MySQL backend.

---

## 🛠️ Tools Used
- **Python (Pandas, NumPy)** – Data preprocessing
- **MySQL** – RFM calculations and segmentation logic
- **Power BI** – Interactive dashboard and visual insights

---

## 📊 Dashboard Highlights

**Page 1: Customer Overview**
- Total Revenue, Customer Count, Order Value
- Churned vs Active Customers (%)
- High / Mid / Low Value Segmentation
- Revenue by State, Top Cities by Orders

**Page 2: Behavioral & RFM Insights**
- Average Recency, Frequency, Monetary (CLV)
- Segment Matrix (Frequency x Monetary)
- Recency trend over time
- Scatter: Recency vs Revenue

---

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
