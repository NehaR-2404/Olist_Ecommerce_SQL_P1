# Olist_Ecommerce_SQL_P1

## Project Overview
This project is a comprehensive SQL analysis of the Olist E-commerce dataset, sourced from [Kaggle](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce). The goal is to extract actionable business insights through data cleaning, SQL queries, and detailed analysis. The project demonstrates SQL proficiency, data cleaning techniques, and the ability to interpret results for business decision-making.

## Data Quality Note
This first version of the project was built using the raw Olist dataset without extensive cleaning. 
As a result, some duplicate records were included in the analysis.  
In future updates, I plan to clean the dataset (remove duplicates, validate keys, and check for nulls) 
to provide more accurate insights.

## Objectives
- Analyze the Olist e-commerce dataset to uncover key business insights.
- Assess customer behavior, including growth, spending, and potential churn.
- Evaluate seller performance based on revenue, ratings, and delivery metrics.
- Identify top-performing products and high-revenue categories.
- Highlight operational challenges such as delivery delays and high cancellation rates.
- Demonstrate SQL proficiency, data cleaning, and analytical reasoning for practical decision-making.

## Data Preparation## 

-The Olist dataset was downloaded from Kaggle and explored to understand the structure and relationships between tables.  
- Checked for null values and handled them during SQL querying to avoid incorrect results.  
- Did not perform full duplicate removal before importing, so some duplicate rows remain in the dataset.  
- Initial attempts to import data directly into tables with primary and foreign keys caused key violation errors.  
- To resolve this, staging tables were created without constraints. Data was loaded into staging, and then inserted into the final tables where keys were enforced to maintain relational integrity.  

**Note:** Future improvements will include cleaning duplicates at the data-loading stage for more robust results.


## SQL Queries & Analysis
The project contains multiple SQL queries addressing key business questions, including:  
1. Customer growth by year  
2. On-time vs late deliveries  
3. Average items per order  
4. Revenue by product category  
5. Delivery times by state  
6. Product reviews  
7. Best-selling products  
8. Revenue growth trends  
9. Top-rated sellers  
10. Seller performance by state  
11. 7-day moving average of daily revenue  
12. Customer inactivity (potential churn)  
13. Seller ranking by delivery performance  
14. Top customers by spending and reviews  
15. Product categories with high cancellation rates  
16. Top customer cities by revenue  
17. Average delivery times by city  
18. Top products by revenue in each category  

## Insights
Insights from the analysis are saved in the `insights.md` file and highlight key findings such as:  
- Rapid growth in customers and revenue over the years  
- Delivery performance challenges in certain regions  
- High-performing sellers and products  
- Categories prone to cancellations  
- High-value customer behavior and satisfaction trends  

## Challenges
- Direct import into PostgreSQL with enforced keys caused key violation errors.  
- Handling relationships between multiple tables required careful staging and validation.  
- Cleaning and transforming large datasets before final insertion was time-consuming but essential for accurate analysis.  

## Learnings
- Importance of staging tables for smooth data import and validation.  
- SQL techniques for aggregation, ranking, joins, and window functions.  
- Interpreting results to provide actionable business insights.  
- Understanding data quality issues and their impact on analysis.  

## Project Structure

```
Olist_Ecommerce_SQL_Project/
├── queries/          # SQL queries used for analysis
├── Query_Results/    # Query results in CSV format
├── insights.md       # Detailed insights from the queries
├── dataset_link.txt  # Link to Kaggle dataset
└── README.md         # Project description and documentation
```

## Tools Used
- PostgreSQL  
- VS Code  
- SQL for querying and analysis  

## Conclusion
This project demonstrates the full data analysis lifecycle: from cleaning and preparing a raw, real-world dataset, to designing robust SQL queries, and deriving actionable business insights. By tackling challenges such as data inconsistencies and relational constraints, the project highlights practical problem-solving skills. The insights obtained provide meaningful understanding of customer behavior, seller performance, and product trends, showing how data-driven decisions can support e-commerce strategy and operational improvements.



