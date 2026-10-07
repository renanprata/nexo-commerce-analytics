-- Taxa por pedido, evitando contagem duplicada de itens.
SELECT count(*) AS completed_orders,
count(*) FILTER(WHERE EXISTS(SELECT 1 FROM commerce.returns r WHERE r.order_id=s.order_id)) AS returned_orders,
round(100.0*count(*) FILTER(WHERE EXISTS(SELECT 1 FROM commerce.returns r WHERE r.order_id=s.order_id))/nullif(count(*),0),2) AS return_rate_pct
FROM analytics.sales_orders s;
