# Data

This project uses the public **Brazilian E-Commerce by Olist** dataset.

The dataset contains multiple relational tables covering orders, order items, customers, products, sellers, payments, reviews, geolocation and category translation.

## Why the raw data is not committed

The complete dataset is large and is not necessary for evaluating the portfolio project. Keeping large raw CSVs out of GitHub makes the repository faster to clone and keeps the repository focused on the analytical work.

Download the Olist dataset from Kaggle and place the CSV files in `data/raw/` using their original filenames.

Expected examples include:

- `olist_orders_dataset.csv`
- `olist_order_items_dataset.csv`
- `olist_customers_dataset.csv`
- `olist_products_dataset.csv`
- `olist_sellers_dataset.csv`
- `olist_order_payments_dataset.csv`
- `olist_order_reviews_dataset.csv`
- `olist_product_category_name_translation.csv`
- `olist_geolocation_dataset.csv`

The SQL schema in `02_SQL_Analysis/schema.sql` defines the corresponding PostgreSQL tables.

## Data caveat

Olist does not provide actual acquisition cost, so this project models contribution using a stated product-cost assumption. The resulting contribution figures should be interpreted as analytical scenarios rather than accounting profit.
