# Gaming Store A/B Test Insights

This project analyses user behaviour and revenue outcomes from an **A/B test experiment** using SQL and Power BI.  
The dataset includes **user sessions, actions, exposures, purchases, and experiments**.  

The goal was to evaluate whether the introduction of a promotional banner (Variant B) improved purchase conversion, revenue, and retention compared to Variant A.

---

## Project Structure
- `SQL/` → SQL scripts answering key analysis questions  
- `csv_data_files/` → Raw datasets (sessions, actions, exposures, purchases, users, experiments)  
- `powerbi_screenshots/` → Screenshots of interactive Power BI dashboards  
- `README.md` → Project documentation (this file)  

---

## SQL Analysis

The SQL analysis answers **8 key business questions**:

1. How many users were exposed to each variant, and how many made a purchase?  
2. What percentage of sessions ended in a purchase in each variant?  
3. Does purchase rate vary by region between variants?  
4. Does purchase rate vary by user type (new vs returning)?  
5. Does purchase rate vary by device (mobile, PC, console)?  
6. Did the banner increase or decrease revenue (after discounts)?  
7. Are users with the banner returning more often (avg sessions per user, % with 2+ sessions)?  
8. Are users in Variant B adding to cart more often, and are they completing purchases?  

### Example Insights
- **Overall Conversion** → Users in Variant B were ~2% more likely to make a purchase.  
- **User Segments** → New mobile users benefited most from the banner, while returning PC/console users were negatively impacted (possible banner fatigue).  
- **Revenue** → Despite higher conversion, Variant B generated **lower total revenue** due to heavier discounts.  
- **Retention** → Users exposed to the banner did **not** return more often. Most completed a **one-time discounted purchase**.  

---

## Power BI A/B Test Insights Dashboard

An interactive Power BI dashboard was built to explore user behaviour and revenue outcomes from the A/B test.

### Key Features

#### **Overview Page**
- Total Users  
- Number of Experiments  
- Total Revenue & Revenue per User  
- Revenue per Variant  
- Monthly Revenue Trends  
- Interactions Breakdown (view, add-to-cart, purchase, click-banner)  
- Variant Distribution  

#### **Purchases Page**
- Total Purchases  
- Discounts vs Non-Discounted Purchases  
- Revenue Breakdown by Variant  
- Purchases per Month  
- User-level Purchase Table  

#### **User Behaviour Page**
- Users Who Made Purchases  
- Average Sessions per User  
- Purchase Conversion %  
- Revenue by User Type (new vs returning)  
- Monthly Active Users  
- Variant Distribution  
