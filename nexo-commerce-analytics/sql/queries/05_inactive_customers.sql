-- Clientes sem pedidos concluídos: inclui quem só cancelou.
SELECT c.customer_id,c.name FROM commerce.customers c
WHERE NOT EXISTS(SELECT 1 FROM analytics.sales_orders s WHERE s.customer_id=c.customer_id) ORDER BY c.customer_id;
