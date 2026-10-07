-- Percentual de compradores com pelo menos dois pedidos concluídos.
WITH frequency AS (SELECT customer_id,count(*) AS orders FROM analytics.sales_orders GROUP BY customer_id)
SELECT count(*) AS buyers,count(*) FILTER(WHERE orders>=2) AS repeat_buyers,
round(100.0*count(*) FILTER(WHERE orders>=2)/nullif(count(*),0),2) AS repeat_purchase_pct FROM frequency;
