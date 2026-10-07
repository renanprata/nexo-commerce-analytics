-- Segmentação RFM com data de referência fixa; empates podem cair em quintis diferentes.
WITH customer_metrics AS (
SELECT customer_id,DATE '2026-01-15'-max(ordered_at) AS recency_days,count(*) AS frequency,sum(net_revenue) AS monetary
FROM analytics.sales_orders GROUP BY customer_id)
SELECT *,ntile(5) OVER(ORDER BY recency_days DESC,customer_id) AS r_score,
ntile(5) OVER(ORDER BY frequency,customer_id) AS f_score,
ntile(5) OVER(ORDER BY monetary,customer_id) AS m_score FROM customer_metrics ORDER BY monetary DESC;
