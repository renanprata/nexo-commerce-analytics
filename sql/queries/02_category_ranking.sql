-- Ranking de categorias por receita líquida.
SELECT c.name,sum(s.net_revenue) AS revenue,
dense_rank() OVER(ORDER BY sum(s.net_revenue) DESC) AS position
FROM analytics.sales_items s JOIN commerce.categories c USING(category_id) GROUP BY c.category_id,c.name ORDER BY position,c.name;
