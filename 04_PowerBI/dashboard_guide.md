# Power BI Dashboard

The report is organized around four business questions.

## 1. Executive Overview

Answers: **How is the business performing?**

Key KPIs:
- Revenue: ₹13.22M
- Orders: ~96K delivered orders
- AOV: ₹137.04
- Freight: ₹2.20M
- Modeled contribution: ₹2.43M
- Modeled contribution margin: 18.4%

The monthly trend and category visuals establish the overall commercial picture before investigating leakage.

## 2. Profit Leakage

Answers: **Where is revenue failing to convert into contribution?**

The page focuses on freight burden and contribution margin by category. Electronics is a key investigation area: approximately ₹45.68K freight against ₹155.04K revenue produces a ~29.5% freight-to-revenue ratio and a modeled contribution margin of ~5.5%.

A 10% Electronics freight reduction is modeled to save approximately ₹4.57K and improve the category's modeled contribution by approximately 53%.

## 3. Operations

Answers: **Is operational performance creating customer or financial leakage?**

The report tracks late delivery, review scores, cancellation/unavailable orders and seller-level freight burden.

The observed late-delivery rate is approximately 8.1%, while average review score is approximately 4.1. The late-vs-on-time view is used as an operational diagnostic rather than proof of causation.

## 4. Customers

Answers: **Where is demand concentrated and how valuable are customers?**

The page covers customer geography, order frequency, revenue concentration and top customers.

The Olist dataset is dominated by one-time customers, so repeat-customer analysis should be treated as a descriptive finding rather than a mature retention program.

## Screenshots

Recommended repository screenshots:

- `assets/executive_overview.png`
- `assets/profit_leakage.png`
- `assets/operations.png`
- `assets/customers.png`
