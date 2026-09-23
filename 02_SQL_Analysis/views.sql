-- Reusable analytical view at order-item grain
CREATE OR REPLACE VIEW delivered_sales AS
SELECT oi.order_id, oi.order_item_id, oi.product_id, oi.seller_id, o.customer_id, o.order_purchase_timestamp,
       oi.price AS revenue, oi.freight_value, p.product_category_name,
       COALESCE(ct.product_category_name_english,p.product_category_name) AS category_english,
       p.product_weight_g, s.seller_state
FROM order_items oi
JOIN orders o ON oi.order_id=o.order_id
JOIN products p ON oi.product_id=p.product_id
JOIN sellers s ON oi.seller_id=s.seller_id
LEFT JOIN category_translation ct ON p.product_category_name=ct.product_category_name
WHERE o.order_status='delivered';
