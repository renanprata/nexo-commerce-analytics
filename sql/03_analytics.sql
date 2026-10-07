BEGIN;
-- Grão: uma linha por item de pedido CONCLUÍDO.
CREATE VIEW analytics.sales_items AS
SELECT o.order_id,o.customer_id,o.ordered_at,o.channel,i.product_id,p.category_id,
 i.quantity,i.unit_price,i.unit_cost,i.discount,
 i.quantity*i.unit_price AS gross_revenue,
 i.quantity*i.unit_price-i.discount AS revenue_after_discount,
 coalesce(r.refund_amount,0) AS refund_amount,
 i.quantity*i.unit_price-i.discount-coalesce(r.refund_amount,0) AS net_revenue,
 (i.quantity-coalesce(r.quantity,0))*i.unit_cost AS net_product_cost,
 i.quantity*i.unit_price-i.discount-coalesce(r.refund_amount,0)
 -(i.quantity-coalesce(r.quantity,0))*i.unit_cost AS product_contribution
FROM commerce.orders o JOIN commerce.order_items i USING(order_id)
JOIN commerce.products p USING(product_id)
LEFT JOIN commerce.returns r ON r.order_id=i.order_id AND r.product_id=i.product_id
WHERE o.status='completed';
-- Agregação evita multiplicar frete/pagamento ao juntar itens.
CREATE VIEW analytics.sales_orders AS
SELECT o.order_id,o.customer_id,o.ordered_at,o.channel,o.shipping_fee,
 sum(s.revenue_after_discount) AS revenue_after_discount,
 sum(s.refund_amount) AS refunds,sum(s.net_revenue) AS net_revenue,
 sum(s.product_contribution) AS product_contribution
FROM commerce.orders o JOIN analytics.sales_items s USING(order_id)
GROUP BY o.order_id;
CREATE VIEW analytics.monthly_kpis AS
SELECT date_trunc('month',ordered_at)::date AS month,count(*) AS orders,
 count(DISTINCT customer_id) AS customers,sum(net_revenue) AS net_revenue,
 round(avg(net_revenue),2) AS average_ticket,
 sum(product_contribution) AS product_contribution,
 round(100*sum(product_contribution)/nullif(sum(net_revenue),0),2) AS contribution_pct
FROM analytics.sales_orders GROUP BY 1;
COMMIT;
