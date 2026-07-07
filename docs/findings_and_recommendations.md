# Findings and Recommendations

## Project: sql-data-analytics-project

This document captures the business findings expected from running the analysis scripts
against the gold layer, and the recommendations that follow from them. Exact figures depend
on the loaded dataset; re-run the scripts after each data refresh and update this file.

---

## Key Findings

1. **Revenue is concentrated in a small set of products.** The Ranking Analysis (`06`) and
   Part-to-Whole Analysis (`10`) typically show that a small number of products/categories
   drive the majority of revenue — a classic Pareto pattern. These products should be
   prioritized for inventory and marketing investment.

2. **Customer value is uneven.** The Data Segmentation script (`11`) and `gold.report_customers`
   view split customers into VIP / Regular / New. VIP customers (long lifespan, high spend)
   are usually a small share of the customer base but a large share of revenue — retention
   programs should target this segment specifically.

3. **Sales trend has seasonality.** The Change-Over-Time script (`07`) surfaces monthly
   peaks and troughs. Any month(s) with a visible dip are candidates for targeted promotions;
   any recurring peak (e.g. end-of-year) should inform inventory planning ahead of time.

4. **Cumulative growth is not always steady.** The Cumulative Analysis script (`08`) shows the
   running total of revenue — flat stretches in the running total indicate periods with no
   net growth and are worth investigating against the same period's change-over-time trend.

5. **Some products under-perform relative to their own history.** The Performance Analysis
   script (`09`) flags products that dropped year-over-year even if their average revenue is
   still positive; these are candidates for review before being flagged as "Low-Performer"
   in `gold.report_products`.

---

## Recommendations

- Focus acquisition and retention marketing on the customer segments identified as VIP.
- Re-evaluate or discontinue products consistently in the "Low-Performer" segment
  (see `gold.report_products.performance_segment`).
- Align inventory and staffing with the seasonal peaks identified in the change-over-time
  and cumulative analyses.
- Track `recency_months` in both report views over time — rising recency across the customer
  or product base is an early warning sign of churn.
- Re-run scripts `01`-`06` (EDA) after every data load as a data-quality sanity check before
  trusting the advanced analytics outputs.
