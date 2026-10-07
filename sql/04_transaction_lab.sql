-- Laboratório reversível: não modifica permanentemente a base.
BEGIN;
SAVEPOINT before_change;
UPDATE commerce.products SET list_price=list_price*1.10 WHERE category_id=1;
SELECT product_id,list_price FROM commerce.products WHERE category_id=1 ORDER BY product_id;
-- Os preços históricos nos itens dos pedidos continuam iguais.
ROLLBACK TO SAVEPOINT before_change;
ROLLBACK;
