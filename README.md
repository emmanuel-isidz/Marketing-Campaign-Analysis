# 📊 Marketing Campaign Analysis Project

This project presents a full-cycle **data analysis** of marketing campaign performance using **SQL** and **Power BI**, aimed at providing actionable business insights for a fictional FMCG (Fast-Moving Consumer Goods) company.

> 🎯 **Objective:** Identify high-performing campaigns, customer segments, and channels that drive revenue, and make data-driven recommendations to optimize marketing ROI.

---

## 🧠 Business Scenario

The company runs multiple campaigns across Email, Social Media, and SMS. Management wants to understand:

- Which campaigns delivered the best ROI?
- Which customer segments convert the most?
- What channels perform best in terms of engagement and conversion?
- How can the company optimize marketing spend?

---

## 📁 Project Structure

```bash
📦marketing-campaign-analysis
 ┣ 📂datasets
 ┃ ┣ customers.csv
 ┃ ┣ campaigns.csv
 ┃ ┣ interactions.csv
 ┃ ┣ purchases.csv
 ┣ 📂sql_queries
 ┃ ┣ marketing_campaign_analysis.sql
 ┣ 📂powerbi_dashboard
 ┃ ┗ campaign_dashboard.pbix
 ┣ README.md
 ┗ ERD.png
```
## 🛠 Tools Used
Task	Tool / Technology
Data Storage & Querying	-MySQL
Data Analysis & KPI Metrics-	SQL
Data Visualization	-Power BI
Project Documentation-	GitHub Markdown

📦 Datasets

customers.csv-customer_id, name, gender, age, location

campaigns.csv-campaign_id, channel, start_date, end_date, cost_usd

interactions.csv-interaction_id, customer_id, campaign_id, interaction_date

purchases.csv-purchase_id, customer_id, campaign_id, date, amount_usd

All datasets are synthetic but modeled to reflect realistic marketing data for B2C sales.

🔍 Key Analyses Performed

📌 1. Exploratory Data Analysis (EDA)
Checked campaign reach, purchase trends, demographics
Created a clean and queryable data model in MySQL

📌 2. Campaign Performance Metrics
Total revenue per campaign
Conversion rates (interactions → purchases)
Campaign-level ROI = (Revenue – Cost) / Cost

📌 3. Customer Segment Insights
Spending and conversion by gender, age, and location
Identified top-performing segments

📌 4. Channel Effectiveness
Engagement vs conversion by channel (Email, Social, SMS)

