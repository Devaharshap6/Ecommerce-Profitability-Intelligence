# E-commerce Profitability & Revenue Leakage Intelligence

Analytics case study using the Olist Brazilian e-commerce dataset.

This project combines PostgreSQL, SQL, Python/Pandas and Power BI to answer: **We are generating revenue, but where exactly are we losing contribution?**

## Scope
- Revenue, orders and AOV
- Category and seller economics
- Freight leakage
- Delivery performance and reviews
- One-time/repeat customer analysis and RFM base metrics
- Four-page Power BI dashboard

## Contribution model

Olist does not provide actual product acquisition cost, so contribution is modeled as:

`Estimated Contribution = Revenue - (Revenue × 65%) - Freight`

The 65% cost assumption is a scenario assumption. These figures are not accounting profit.

## Key findings

- Delivered-order revenue: approximately **₹13.22M**
- Modeled contribution: approximately **₹2.43M**
- Modeled contribution margin: approximately **18.4%**
- Electronics freight burden: approximately **29.46% of revenue**
- Electronics modeled contribution margin: approximately **5.5%**
- A modeled 10% reduction in Electronics freight adds approximately **₹4,568** of contribution, about **53%** of current modeled contribution for that category
- The weight-band test indicates product weight alone does not explain Electronics freight leakage

## Project structure

```text
Ecommerce-Profitability-Intelligence/
├── data/
│   ├── raw/
│   └── cleaned/
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
│   └── README.md
├── 05_Business_Recommendations/
│   └── recommendations.md
└── requirements.txt
```

## Limitations

The public Olist dataset does not provide actual acquisition costs, explicit item-level discounts, complete return/refund economics, or carrier-level logistics costs. Profitability results therefore remain modeled estimates.

## Reproducibility

1. Load the Olist CSVs into PostgreSQL using `02_SQL_Analysis/schema.sql`.
2. Run `02_SQL_Analysis/business_queries.sql`.
3. Run the Python notebooks.
4. Open the Power BI report and point the model to the local PostgreSQL database.
