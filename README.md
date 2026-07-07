# SQL Data Analytics Project

A full SQL Server data analytics layer built on top of the
[sql-medallion-architecture-data-warehouse-full-project](https://github.com/ahmadazharinfo/sql-medallion-architecture-data-warehouse-full-project).
Where the previous project built the warehouse (Bronze -> Silver -> Gold), this project
consumes the Gold layer to answer real business questions, following the EDA -> Advanced
Analytics -> Reporting flow.

---

## Analytics Flow

**Exploratory Data Analysis (EDA)** - understand the data before analyzing it:
`Database Exploration -> Dimensions Exploration -> Date Exploration -> Measures Exploration -> Magnitude Analysis -> Ranking Analysis`

**Advanced Analytics** — turn the data into business insight:
`Change-Over-Time Trends -> Cumulative Analysis -> Performance Analysis -> Part-to-Whole Analysis -> Data Segmentation -> Reporting`

---

## Project Structure

```
sql-data-analytics-project/
│
├── scripts/
│   ├── 00_init_analytics.sql                 # Connects to the existing DataWarehouse DB
│   │
│   ├── 01_eda_database_exploration.sql       # EDA: Database Exploration
│   ├── 02_eda_dimensions_exploration.sql     # EDA: Dimensions Exploration
│   ├── 03_eda_date_exploration.sql           # EDA: Date Exploration
│   ├── 04_eda_measures_exploration.sql       # EDA: Measures Exploration (Big Numbers)
│   ├── 05_eda_magnitude_analysis.sql         # EDA: Magnitude Analysis
│   ├── 06_eda_ranking_analysis.sql           # EDA: Ranking Analysis (Top N / Bottom N)
│   │
│   ├── 07_adv_change_over_time_analysis.sql  # Advanced Analytics: Change-Over-Time Trends
│   ├── 08_adv_cumulative_analysis.sql        # Advanced Analytics: Cumulative Analysis
│   ├── 09_adv_performance_analysis.sql       # Advanced Analytics: Performance Analysis (YoY)
│   ├── 10_adv_part_to_whole_analysis.sql     # Advanced Analytics: Part-to-Whole Analysis
│   ├── 11_adv_data_segmentation.sql          # Advanced Analytics: Data Segmentation
│   ├── 12_adv_report_customers.sql           # Advanced Analytics: Reporting -> gold.report_customers
│   └── 13_adv_report_products.sql            # Advanced Analytics: Reporting -> gold.report_products
│
├── docs/
│   └── findings_and_recommendations.md       # Business findings and recommended actions
│
└── README.md
```

---

## Prerequisite

This project reads from the Gold layer only. Build the warehouse first:

1. Run the warehouse project's `scripts/init_database.sql`, `ddl_bronze.sql`,
   `proc_load_bronze.sql`, `ddl_silver.sql`, `proc_load_silver.sql`, `ddl_gold.sql`.
2. Confirm `gold.dim_customers`, `gold.dim_products`, and `gold.fact_sales` exist.

## How to Run

1. `scripts/00_init_analytics.sql` - connects to `DataWarehouse` and sanity-checks the gold views.
2. Run scripts `01` through `06` in order for the EDA pass.
3. Run scripts `07` through `11` in order for the advanced analytics pass.
4. Run `12_adv_report_customers.sql` and `13_adv_report_products.sql` to create the two
   final reporting views:
   - `gold.report_customers` - one row per customer, with segment, recency, AOV, and
     average monthly spend.
   - `gold.report_products` - one row per product, with performance segment, recency,
     average order revenue, and average monthly revenue.
5. Query the two report views directly for dashboards (Power BI, Excel) or ad-hoc analysis:
   ```sql
   SELECT * FROM gold.report_customers ORDER BY total_sales DESC;
   SELECT * FROM gold.report_products  ORDER BY total_sales DESC;
   ```

See `docs/findings_and_recommendations.md` for the business takeaways derived from this analysis.
