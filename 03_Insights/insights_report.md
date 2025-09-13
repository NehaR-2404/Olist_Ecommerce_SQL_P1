# Insights Report – Olist E-commerce SQL Project  

This report summarizes insights derived from exploratory and advanced SQL queries on the Olist dataset after cleaning and staging.  

---

## SECTION B: BASIC QUERY ANALYSIS  

### Q1. How many unique customers placed an order each year?  
📊 Insight: Customer growth on Olist shows massive expansion. In 2016, only 329 unique customers placed orders, but this surged to 45,101 in 2017 and 54,011 in 2018. The largest growth occurred between 2016 and 2017, indicating rapid adoption and platform scaling.  

### Q2. What percentage of orders were delivered late vs. on time?  
📊 Insight: Most orders were delivered on time, though punctuality decreased slightly over time. On-time deliveries dropped from 98.9% in 2016 to 92.27% in 2018, while late deliveries increased from 1.1% to 7.73%, reflecting challenges in scaling logistics as order volume grew.  

### Q3. What is the average number of items per order?  
📊 Insight: Average items per order stayed stable around 1.14–1.19, showing that customers mostly placed small, single-item orders over the three years.  

### Q4. Top product categories by total revenue  
📊 Insight: “beleza_saude” and “relogios_presentes” are top revenue-generating categories, each earning over R$1.3M, followed by “cama_mesa_banho” and “esporte_lazer.” Lower-revenue categories like “bebes” generated ~R$480K. This highlights core revenue streams and growth potential.  

### Q5. Average delivery time per state  
📊 Insight: Delivery times vary by state. Slowest deliveries: Roraima (29.34 days) and Amapá (27.18 days). Fastest: Tocantins (17.60 days) and Mato Grosso (18.00 days). Geography significantly impacts delivery speed, likely due to distance from warehouses or regional logistics challenges.  

### Q6. Average review score by product category  
📊 Insight: Most categories maintain high ratings, e.g., “cds_dvds_musicais” at 4.64 and “fashion_roupa_infanto_juvenil” at 4.50. Lowest-rated: “seguros_e_servicos” at 2.50. Overall, customer satisfaction is strong across most categories.  

---

## SECTION C: ADVANCED QUERY ANALYSIS  

### Q7. Top 3 best-selling products per category (by revenue)  
📊 Insight: Top products dominate category revenue. For example, in “beleza_saude,” the top product earned R$67,606.10 vs. R$26,659.74 for the third. In “bebes,” the top product reached R$40,311.95. Sales concentration at the product level is clear across Olist.  

### Q8. Track monthly revenue growth and calculate MoM %  
📊 Insight: Monthly revenue shows strong growth and fluctuations. Revenue rose from R$143.46 in September 2016 to over R$1M in early 2017. Month-to-month changes included double-digit growth and occasional drops (e.g., -26.90% in Dec 2017). The 2018 revenue stabilized around R$1M monthly, highlighting scaling trends with typical volatility.  

### Q9. Top 5 sellers with highest average review score (min 50 orders)  
📊 Insight: Highest-rated sellers achieve excellent customer satisfaction (4.67–4.82). These sellers provide high-quality service, building trust and encouraging repeat purchases.  

### Q10. Rank sellers within each state based on total sales and avg rating  
📊 Insight: Top sellers generate substantial revenue while maintaining strong service metrics. Some achieve high revenue with slightly lower ratings; others balance strong ratings with faster deliveries. Different strategies—volume-driven, high-quality service, or optimized delivery—can drive seller success.  

### Q11. 7-day moving average of daily sales revenue  
📊 Insight: The 7-day moving average smooths daily revenue fluctuations, showing overall trends. Despite daily spikes (e.g., R$595.14 on 2016-10-03), the average rose steadily from R$136.23 to R$211.85, aiding trend identification, inventory planning, and cash flow forecasting.  

### Q12. Customers inactive for last 6 months of 2018  
📊 Insight: Customers inactive since mid-2018 indicate potential churn. Most had last orders in 2016. Tracking them helps Olist design re-engagement campaigns, personalized offers, or loyalty programs to reduce churn and improve lifetime value.  

### Q13. Rank sellers by delivery performance (early delivery %)  
📊 Insight: Top sellers consistently deliver earlier than estimated, improving operational efficiency and customer satisfaction. For example, the leading seller delivered 15 orders 1500% early, averaging 21 days ahead. Even small sellers can outperform in delivery metrics, setting benchmarks for others.  

### Q14. Top 10 customers by total spending and their average review score  
📊 Insight: High-spending customers contribute significantly, e.g., over R$13K per customer. Some provide excellent reviews (5), while others give low ratings (0–1), highlighting that spending does not always equal satisfaction. Monitoring both revenue and sentiment supports tailored retention strategies.  

### Q15. Product categories with highest cancellation rate  
📊 Insight: “pc_gamer” leads with 11.11% cancellations, followed by kitchen appliances and DVDs. High-value or niche items are more likely to be canceled, whereas high-volume categories like musical instruments or books have lower rates. Understanding cancellation patterns helps optimize inventory, descriptions, and fulfillment.  

### Q16. Top 10 customer cities by revenue (Geolocation)  
📊 Insight: Revenue concentrates in urban centers. Rio de Janeiro leads with R$313M across 6,641 orders. São Paulo has more orders but lower average order value. Other cities like Belo Horizonte, Niterói, and Curitiba contribute significantly. Salvador shows the highest average order value (R$171.91), suggesting fewer high-value purchases.  

### Q17. Average delivery time by customer city (Geolocation)  
📊 Insight: Small cities like Embaúba (SP) and Cambará do Sul (RS) achieve the fastest deliveries at 4 days. Less congested regions can fulfill orders faster than major urban centers.  

### Q18. Top 5 products by revenue in each English product category  
📊 Insight: Each category has clear revenue leaders, e.g., baby products top at R$40,311.95 and computer accessories at R$60,976.03. These insights guide inventory prioritization and marketing focus.  

---

# Overall Conclusion  
The analysis shows strong growth in Olist’s customer base and revenue, but challenges remain in logistics (late deliveries, regional gaps) and product categories (high cancellations). High-value customers and top sellers drive most performance, showing value concentration. Insights can guide operational improvements, marketing strategies, and inventory focus to enhance profitability and customer satisfaction.
