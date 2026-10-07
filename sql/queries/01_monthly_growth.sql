-- Receita mensal e variação: meses sem vendas aparecem com zero.
WITH months AS (SELECT generate_series(DATE '2025-01-01',DATE '2025-12-01',INTERVAL '1 month')::date AS month), series AS (
SELECT m.month,coalesce(k.net_revenue,0) AS revenue FROM months m LEFT JOIN analytics.monthly_kpis k USING(month)), previous AS (
SELECT *,lag(revenue) OVER(ORDER BY month) AS previous_revenue FROM series)
SELECT *,round(100*(revenue-previous_revenue)/nullif(previous_revenue,0),2) AS growth_pct FROM previous ORDER BY month;
