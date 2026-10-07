-- Participação percentual por canal.
SELECT channel,sum(net_revenue) AS net_revenue,
round(100*sum(net_revenue)/nullif(sum(sum(net_revenue)) OVER(),0),2) AS share_pct
FROM analytics.sales_orders GROUP BY channel ORDER BY net_revenue DESC;
