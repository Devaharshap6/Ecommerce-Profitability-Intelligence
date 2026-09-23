# E-commerce Profitability & Revenue Leakage Intelligence

An end-to-end analytics case study built around the Olist Brazilian e-commerce dataset.

> **Business question:** We are generating revenue, but where exactly are we losing contribution?

This project deliberately goes beyond a sales dashboard. SQL, Python and Power BI are used to identify freight leakage, low-margin categories, operational friction and the potential financial impact of corrective actions.

## Business outcome

The analysis models contribution using a stated 65% product-cost assumption because Olist does not provide actual acquisition cost.

`Estimated Contribution = Revenue - (Revenue × 65%) - Freight`

This is a scenario model, **not accounting profit**.

### Key findings

| Metric | Result |
|---|---:|
| Delivered-order revenue | ~₹13.22M |
| Delivered orders | ~96K |
| AOV | ₹137.04 |
| Freight | ~₹2.20M |
| Modeled contribution | ~₹2.43M |
| Modeled contribution margin | 18.4% |
| Electronics freight / revenue | ~29.5% |
| Electronics modeled contribution margin | ~5.5% |
| Electronics freight savings at 10% reduction | ~₹4.57K |

The strongest investigation is not simply that Electronics has high revenue. It is that a disproportionate freight burden leaves the category with a relatively weak modeled contribution margin. A 10% reduction in Electronics freight would add approximately ₹4.57K to modeled contribution under the same assumptions.

## Dashboard

The Power BI report contains four business-facing pages:

1. **Executive Overview** — revenue, orders, AOV, freight, contribution and category performance.
2. **Profit Leakage** — freight burden, contribution margin and category-level leakage opportunities.
3. **Operations** — late delivery, review scores, seller freight burden and order-status outcomes.
4. **Customers** — customer concentration, geography, order frequency and revenue concentration.

See [`04_PowerBI/dashboard_guide.md`](04_PowerBI/dashboard_guide.md) for the analytical purpose and interpretation of each page.

## Analytical workflow

```text
Olist CSVs
   ↓
Python / Pandas
Data cleaning + validation
   ↓
PostgreSQL
Relational analysis + business queries
   ↓
Python / EDA
Patterns + outliers + diagnostics
   ↓
Power BI
Executive reporting + drill-downs
   ↓
Business Recommendations
Actions + scenario analysis
```

## Project structure

```text
Ecommerce-Profitability-Intelligence/
├── data/
│   └── README.md
├── 01_Data_Cleaning/
│   └── cleaning.ipynb
├── 02_SQL_Analysis/
│   ├── schema.sql
│   ├── create_tables.sql
│   ├── business_queries.sql
│   └── views.sql
├── 03_Python_EDA/
│   └── eda.ipynb
├── 04_PowerBI/
│   ├── dashboard_guide.md
│   └── Ecommerce_Profitability.pbix  # add locally if desired
├── 05_Business_Recommendations/
│   └── recommendations.md
├── .gitignore
├── requirements.txt
└── README.md
```

## Tools

- **PostgreSQL** — relational data model and SQL investigation
- **SQL** — joins, CTEs, aggregations, CASE logic and window functions
- **Python / Pandas** — cleaning, EDA and diagnostic analysis
- **Power BI** — semantic model, DAX measures, KPIs and executive dashboarding
- **Excel** — supporting analysis / validation where required

## Limitations

The public Olist dataset does not provide actual acquisition cost, complete discount economics, full return/refund economics or carrier-level logistics costs. Therefore contribution and savings figures are modeled estimates. The recommendations should be validated against actual finance and logistics data before implementation.

The late-delivery/review comparison is descriptive and should not be interpreted as proof of causation.

## Reproducibility

1. Download the Olist dataset and place the CSVs under `data/raw/`.
2. Create the PostgreSQL tables using `02_SQL_Analysis/schema.sql` and `create_tables.sql`.
3. Load the CSV data into PostgreSQL.
4. Run `02_SQL_Analysis/business_queries.sql` and `views.sql`.
5. Run the notebooks under `01_Data_Cleaning/` and `03_Python_EDA/`.
6. Open the Power BI report and connect it to the PostgreSQL model.
7. Review the recommendations in `05_Business_Recommendations/recommendations.md`.
