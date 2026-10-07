BEGIN;
CREATE SCHEMA commerce;
CREATE SCHEMA analytics;
CREATE TABLE commerce.customers (
 customer_id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
 name text NOT NULL CHECK(length(trim(name))>0),
 email text NOT NULL UNIQUE CHECK(email=lower(email)),
 city text NOT NULL, state char(2) NOT NULL,
 registered_at date NOT NULL
);
CREATE TABLE commerce.categories (
 category_id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
 name text NOT NULL UNIQUE
);
CREATE TABLE commerce.products (
 product_id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
 category_id bigint NOT NULL REFERENCES commerce.categories,
 sku text NOT NULL UNIQUE, name text NOT NULL,
 list_price numeric(12,2) NOT NULL CHECK(list_price>0),
 unit_cost numeric(12,2) NOT NULL CHECK(unit_cost>=0),
 active boolean NOT NULL DEFAULT true
);
CREATE TABLE commerce.orders (
 order_id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
 customer_id bigint NOT NULL REFERENCES commerce.customers,
 ordered_at date NOT NULL,
 status text NOT NULL CHECK(status IN ('completed','cancelled','pending')),
 channel text NOT NULL CHECK(channel IN ('site','marketplace','store')),
 shipping_fee numeric(12,2) NOT NULL DEFAULT 0 CHECK(shipping_fee>=0)
);
CREATE TABLE commerce.order_items (
 order_id bigint NOT NULL REFERENCES commerce.orders,
 product_id bigint NOT NULL REFERENCES commerce.products,
 quantity integer NOT NULL CHECK(quantity>0),
 unit_price numeric(12,2) NOT NULL CHECK(unit_price>0),
 unit_cost numeric(12,2) NOT NULL CHECK(unit_cost>=0),
 discount numeric(12,2) NOT NULL DEFAULT 0 CHECK(discount>=0 AND discount<=quantity*unit_price),
 PRIMARY KEY(order_id,product_id)
);
CREATE TABLE commerce.payments (
 payment_id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
 order_id bigint NOT NULL UNIQUE REFERENCES commerce.orders,
 method text NOT NULL CHECK(method IN ('pix','credit','debit')),
 status text NOT NULL CHECK(status IN ('approved','pending','failed')),
 amount numeric(12,2) NOT NULL CHECK(amount>=0),
 paid_at date,
 CHECK((status='approved' AND paid_at IS NOT NULL) OR (status<>'approved' AND paid_at IS NULL))
);
-- Uma devolução agregada por item. Não modela múltiplas solicitações do mesmo item.
CREATE TABLE commerce.returns (
 return_id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
 order_id bigint NOT NULL, product_id bigint NOT NULL,
 quantity integer NOT NULL CHECK(quantity>0),
 refund_amount numeric(12,2) NOT NULL CHECK(refund_amount>=0),
 returned_at date NOT NULL, reason text NOT NULL,
 UNIQUE(order_id,product_id),
 FOREIGN KEY(order_id,product_id) REFERENCES commerce.order_items
);
CREATE INDEX orders_customer_date_idx ON commerce.orders(customer_id,ordered_at);
CREATE INDEX orders_date_completed_idx ON commerce.orders(ordered_at) WHERE status='completed';
CREATE INDEX items_product_idx ON commerce.order_items(product_id);
CREATE INDEX products_category_idx ON commerce.products(category_id);
CREATE INDEX returns_item_idx ON commerce.returns(order_id,product_id);
-- Regras entre tabelas precisam de trigger, não de CHECK com subconsulta.
CREATE FUNCTION commerce.validate_return() RETURNS trigger LANGUAGE plpgsql AS $$
DECLARE item commerce.order_items%ROWTYPE; sale commerce.orders%ROWTYPE;
BEGIN
 SELECT * INTO item FROM commerce.order_items WHERE order_id=NEW.order_id AND product_id=NEW.product_id FOR UPDATE;
 IF NOT FOUND THEN RAISE EXCEPTION 'Item inexistente'; END IF;
 SELECT * INTO sale FROM commerce.orders WHERE order_id=NEW.order_id;
 IF sale.status<>'completed' OR NEW.returned_at<sale.ordered_at OR NEW.quantity>item.quantity
 OR NEW.refund_amount>round((item.quantity*item.unit_price-item.discount)*NEW.quantity/item.quantity,2)
 THEN RAISE EXCEPTION 'Devolução inválida'; END IF;
 RETURN NEW;
END $$;
CREATE TRIGGER validate_return BEFORE INSERT OR UPDATE ON commerce.returns
FOR EACH ROW EXECUTE FUNCTION commerce.validate_return();
COMMENT ON COLUMN commerce.order_items.unit_price IS 'Preço histórico; não acompanha mudanças do catálogo.';
COMMENT ON COLUMN commerce.order_items.unit_cost IS 'Custo histórico para análise da margem de contribuição dos produtos.';
COMMIT;
