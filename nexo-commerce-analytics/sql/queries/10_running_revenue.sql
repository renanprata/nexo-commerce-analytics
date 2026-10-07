-- Receita acumulada por mês.
SELECT month,net_revenue,sum(net_revenue) OVER(ORDER BY month ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS cumulative_revenue
FROM analytics.monthly_kpis ORDER BY month;
