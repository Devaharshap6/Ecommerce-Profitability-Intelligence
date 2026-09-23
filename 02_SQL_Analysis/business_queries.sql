-- E-commerce Profitability & Revenue Leakage Intelligence
-- Core business analysis queries

-- 1. Total realized revenue (delivered orders)
SELECT SUM(oi.price) AS realized_revenue
FROM order_items oi
JOIN orders o ON oi.order_id = o.order_id
WHERE o.order_status = 'delivered';

-- 2. Monthly revenue, orders and AOV
SELECT DATE_TRUNC('month', o.order_purchase_timestamp) AS month,
       SUM(oi.price) AS revenue,
       COUNT(DISTINCT o.order_id) AS orders,
       SUM(oi.price) / NULLIF(COUNT(DISTINCT o.order_id),0) AS aov
FROM order_items oi
JOIN orders o ON oi.order_id = o.order_id
WHERE o.order_status = 'delivered'
GROUP BY 1 ORDER BY 1;

-- 3. Category revenue and orders
SELECT COALESCE(ct.product_category_name_english, p.product_category_name) AS category,
       SUM(oi.price) AS revenue,
       COUNT(DISTINCT oi.order_id) AS orders
FROM order_items oi
JOIN orders o ON oi.order_id = o.order_id
JOIN products p ON oi.product_id = p.product_id
LEFT JOIN category_translation ct ON p.product_category_name = ct.product_category_name
WHERE o.order_status = 'delivered'
GROUP BY 1 ORDER BY revenue DESC;

-- 4. Category modeled contribution and margin
WITH category_analysis AS (
    SELECT COALESCE(ct.product_category_name_english, p.product_category_name) AS category,
           SUM(oi.price) AS revenue,
           SUM(oi.price - (oi.price * 0.65) - oi.freight_value) AS estimated_contribution
    FROM order_items oi
    JOIN orders o ON oi.order_id = o.order_id
    JOIN products p ON oi.product_id = p.product_id
    LEFT JOIN category_translation ct ON p.product_category_name = ct.product_category_name
    WHERE o.order_status = 'delivered'
    GROUP BY 1
)
SELECT category, ROUND(revenue,2) AS revenue, ROUND(estimated_contribution,2) AS estimated_contribution,
       ROUND(100.0 * estimated_contribution / NULLIF(revenue,0),2) AS contribution_margin_pct,
       ROUND(100.0 * revenue / SUM(revenue) OVER (),2) AS revenue_share_pct,
       ROUND(100.0 * estimated_contribution / NULLIF(SUM(estimated_contribution) OVER (),0),2) AS contribution_share_pct
FROM category_analysis
ORDER BY revenue DESC;

-- 5. High-volume categories by freight burden
SELECT COALESCE(ct.product_category_name_english, p.product_category_name) AS category,
       SUM(oi.price) AS revenue,
       SUM(oi.freight_value) AS freight,
       ROUND(100.0 * SUM(oi.freight_value) / NULLIF(SUM(oi.price),0),2) AS freight_pct
FROM order_items oi
JOIN orders o ON oi.order_id = o.order_id
JOIN products p ON oi.product_id = p.product_id
LEFT JOIN category_translation ct ON p.product_category_name = ct.product_category_name
WHERE o.order_status = 'delivered'
GROUP BY 1
HAVING SUM(oi.price) >= 100000
ORDER BY freight_pct DESC;

-- 6. Electronics leakage
SELECT COALESCE(ct.product_category_name_english, p.product_category_name) AS category,
       SUM(oi.price) AS revenue,
       SUM(oi.freight_value) AS freight,
       SUM(oi.price * 0.65) AS estimated_product_cost,
       SUM(oi.price - (oi.price * 0.65) - oi.freight_value) AS estimated_contribution,
       ROUND(100.0 * SUM(oi.price - (oi.price * 0.65) - oi.freight_value) / NULLIF(SUM(oi.price),0),2) AS contribution_margin_pct
FROM order_items oi
JOIN orders o ON oi.order_id = o.order_id
JOIN products p ON oi.product_id = p.product_id
LEFT JOIN category_translation ct ON p.product_category_name = ct.product_category_name
WHERE o.order_status = 'delivered'
  AND COALESCE(ct.product_category_name_english, p.product_category_name) = 'electronics'
GROUP BY 1;

-- 7. Electronics seller scorecard
SELECT oi.seller_id, COUNT(DISTINCT oi.order_id) AS orders, SUM(oi.price) AS revenue,
       SUM(oi.freight_value) AS freight,
       SUM(oi.price - (oi.price * 0.65) - oi.freight_value) AS estimated_contribution,
       ROUND(100.0 * SUM(oi.freight_value) / NULLIF(SUM(oi.price),0),2) AS freight_pct,
       ROUND(100.0 * SUM(oi.price - (oi.price * 0.65) - oi.freight_value) / NULLIF(SUM(oi.price),0),2) AS contribution_margin_pct
FROM order_items oi
JOIN orders o ON oi.order_id = o.order_id
JOIN products p ON oi.product_id = p.product_id
LEFT JOIN category_translation ct ON p.product_category_name = ct.product_category_name
WHERE o.order_status = 'delivered'
  AND COALESCE(ct.product_category_name_english, p.product_category_name) = 'electronics'
GROUP BY 1 HAVING SUM(oi.price) >= 5000 ORDER BY freight_pct DESC;

-- 8. Electronics weight-band hypothesis
SELECT CASE WHEN p.product_weight_g < 1000 THEN 'Under 1kg'
            WHEN p.product_weight_g < 3000 THEN '1-3kg'
            WHEN p.product_weight_g < 5000 THEN '3-5kg' ELSE '5kg+' END AS weight_band,
       COUNT(*) AS items, SUM(oi.price) AS revenue, SUM(oi.freight_value) AS freight,
       ROUND(100.0 * SUM(oi.freight_value) / NULLIF(SUM(oi.price),0),2) AS freight_pct
FROM order_items oi
JOIN orders o ON oi.order_id=o.order_id
JOIN products p ON oi.product_id=p.product_id
LEFT JOIN category_translation ct ON p.product_category_name=ct.product_category_name
WHERE o.order_status='delivered'
  AND COALESCE(ct.product_category_name_english,p.product_category_name)='electronics'
GROUP BY 1 ORDER BY 1;

-- 9. Late-delivery KPI
SELECT COUNT(*) FILTER (WHERE order_status='delivered') AS delivered_orders,
       COUNT(*) FILTER (WHERE order_status='delivered' AND order_delivered_customer_date IS NOT NULL) AS orders_with_delivery_date,
       COUNT(*) FILTER (WHERE order_status='delivered' AND order_delivered_customer_date > order_estimated_delivery_date) AS late_orders,
       ROUND(100.0 * COUNT(*) FILTER (WHERE order_status='delivered' AND order_delivered_customer_date > order_estimated_delivery_date) / NULLIF(COUNT(*) FILTER (WHERE order_status='delivered' AND order_delivered_customer_date IS NOT NULL),0),2) AS late_delivery_pct
FROM orders;

-- 10. Late vs on-time reviews
SELECT CASE WHEN o.order_delivered_customer_date > o.order_estimated_delivery_date THEN 'Late' ELSE 'On Time' END AS delivery_status,
       COUNT(*) AS orders, ROUND(AVG(r.review_score),2) AS avg_review_score
FROM orders o JOIN reviews r ON o.order_id=r.order_id
WHERE o.order_status='delivered' AND o.order_delivered_customer_date IS NOT NULL
GROUP BY 1;

-- 11. Cancellation / unavailable rate
SELECT COUNT(*) AS total_orders,
       COUNT(*) FILTER (WHERE order_status='canceled') AS canceled_orders,
       COUNT(*) FILTER (WHERE order_status='unavailable') AS unavailable_orders,
       ROUND(100.0 * COUNT(*) FILTER (WHERE order_status IN ('canceled','unavailable')) / COUNT(*),2) AS cancellation_unavailable_pct
FROM orders;

-- 12. One-time vs repeat customers
WITH customer_orders AS (
    SELECT customer_id, COUNT(DISTINCT order_id) AS order_count
    FROM orders WHERE order_status='delivered' GROUP BY 1
)
SELECT CASE WHEN order_count=1 THEN 'One-time' ELSE 'Repeat' END AS customer_type, COUNT(*) AS customers
FROM customer_orders GROUP BY 1;

-- 13. RFM base metrics
SELECT o.customer_id, MAX(o.order_purchase_timestamp) AS last_order_date,
       COUNT(DISTINCT o.order_id) AS frequency, SUM(oi.price) AS monetary
FROM orders o JOIN order_items oi ON o.order_id=oi.order_id
WHERE o.order_status='delivered'
GROUP BY 1 ORDER BY monetary DESC;

-- 14. Seller scorecard
WITH seller_analysis AS (
    SELECT oi.seller_id, COUNT(DISTINCT oi.order_id) AS orders, SUM(oi.price) AS revenue, SUM(oi.freight_value) AS freight,
           SUM(oi.price - (oi.price * 0.65) - oi.freight_value) AS contribution
    FROM order_items oi JOIN orders o ON oi.order_id=o.order_id
    WHERE o.order_status='delivered' GROUP BY 1
)
SELECT seller_id, orders, ROUND(revenue,2) AS revenue, ROUND(freight,2) AS freight, ROUND(contribution,2) AS contribution,
       ROUND(100.0*freight/NULLIF(revenue,0),2) AS freight_pct,
       ROUND(100.0*contribution/NULLIF(revenue,0),2) AS contribution_margin_pct,
       ROUND(freight*0.10,2) AS potential_freight_savings
FROM seller_analysis WHERE revenue>=10000 ORDER BY potential_freight_savings DESC;
