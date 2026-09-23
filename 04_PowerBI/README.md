# Power BI

The Power BI report is maintained as a local `.pbix` file because Power BI Desktop files are binary. The report contains four pages:

1. Executive Overview
2. Profit Leakage
3. Operations
4. Customers

Core measures include Revenue, Orders, AOV, Freight, Estimated Product Cost, Contribution, Contribution Margin and Freight %.

The model connects to the local PostgreSQL database `ecommerce_profitability` on port `5433`. Update the connection for another machine.
