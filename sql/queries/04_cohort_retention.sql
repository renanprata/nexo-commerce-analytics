-- Retenção por mês desde a primeira compra; não mede retenção contínua.
WITH purchases AS (
SELECT DISTINCT customer_id,date_trunc('month',ordered_at)::date AS month FROM analytics.sales_orders), first_purchase AS (
SELECT customer_id,min(month) AS cohort FROM purchases GROUP BY customer_id), cohort_sizes AS (
SELECT cohort,count(*) AS initial_customers FROM first_purchase GROUP BY cohort), activity AS (
SELECT f.cohort,(extract(year FROM p.month)::int-extract(year FROM f.cohort)::int)*12+
extract(month FROM p.month)::int-extract(month FROM f.cohort)::int AS month_number,
count(*) AS active_customers FROM purchases p JOIN first_purchase f USING(customer_id) GROUP BY 1,2)
SELECT a.*,c.initial_customers,round(100.0*a.active_customers/c.initial_customers,2) AS retention_pct
FROM activity a JOIN cohort_sizes c USING(cohort) ORDER BY cohort,month_number;
