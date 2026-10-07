BEGIN;
-- Dados 100% fictícios e determinísticos. Não representam empresas ou pessoas reais.
INSERT INTO commerce.categories(name) VALUES ('Casa'),('Tecnologia'),('Acessórios'),('Papelaria');
INSERT INTO commerce.customers(name,email,city,state,registered_at)
SELECT 'Cliente fictício '||g,'cliente'||g||'@example.invalid',
 (ARRAY['São Carlos','Araraquara','Campinas','São Paulo'])[1+(g%4)],'SP',
 DATE '2024-12-01'+(g%30) FROM generate_series(1,240) g;
INSERT INTO commerce.products(category_id,sku,name,list_price,unit_cost)
SELECT 1+(g%4),'NX-'||lpad(g::text,3,'0'),'Produto demonstrativo '||g,
 25+(g%12)*15,10+(g%12)*7 FROM generate_series(1,40) g;
INSERT INTO commerce.orders(customer_id,ordered_at,status,channel,shipping_fee)
SELECT 1+((g*37)%220), DATE '2025-01-01'+((g*17)%365),
 CASE WHEN g%19=0 THEN 'cancelled' WHEN g%23=0 THEN 'pending' ELSE 'completed' END,
 (ARRAY['site','marketplace','store'])[1+(g%3)],CASE WHEN g%3=2 THEN 0 ELSE 12.90 END
FROM generate_series(1,1800) g;
INSERT INTO commerce.order_items(order_id,product_id,quantity,unit_price,unit_cost,discount)
SELECT o.order_id,p.product_id,1+(o.order_id%3),p.list_price,p.unit_cost,
 CASE WHEN o.order_id%7=0 THEN round(p.list_price*0.1,2) ELSE 0 END
FROM commerce.orders o CROSS JOIN generate_series(0,2) n
JOIN commerce.products p ON p.product_id=1+((o.order_id*7+n*11)%40)
WHERE n<1+(o.order_id%3);
INSERT INTO commerce.payments(order_id,method,status,amount,paid_at)
SELECT o.order_id,(ARRAY['pix','credit','debit'])[1+(o.order_id%3)],
 CASE o.status WHEN 'completed' THEN 'approved' WHEN 'pending' THEN 'pending' ELSE 'failed' END,
 sum(i.quantity*i.unit_price-i.discount)+o.shipping_fee,
 CASE WHEN o.status='completed' THEN o.ordered_at ELSE NULL END
FROM commerce.orders o JOIN commerce.order_items i USING(order_id) GROUP BY o.order_id;
INSERT INTO commerce.returns(order_id,product_id,quantity,refund_amount,returned_at,reason)
SELECT i.order_id,i.product_id,1,round((i.quantity*i.unit_price-i.discount)/i.quantity,2),
 o.ordered_at+7,'Desistência simulada'
FROM commerce.order_items i JOIN commerce.orders o USING(order_id)
WHERE o.status='completed' AND i.order_id%17=0 AND i.product_id=(SELECT min(x.product_id) FROM commerce.order_items x WHERE x.order_id=i.order_id);
COMMIT;
