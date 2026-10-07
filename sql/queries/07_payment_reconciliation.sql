-- Reconciliação do valor original; devoluções não alteram pagamentos históricos.
SELECT o.order_id,p.amount,sum(i.quantity*i.unit_price-i.discount)+o.shipping_fee AS expected_amount
FROM commerce.orders o JOIN commerce.order_items i USING(order_id) JOIN commerce.payments p USING(order_id)
GROUP BY o.order_id,p.amount HAVING p.amount<>sum(i.quantity*i.unit_price-i.discount)+o.shipping_fee;
