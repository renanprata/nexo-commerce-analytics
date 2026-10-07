# Trilha prática de SQL

Faça primeiro sem consultar as soluções em `sql/queries`. Crie `sql/my-solutions/` e registre suas tentativas em commits.

## Etapa 1 — explorar
1. Liste produtos ativos acima de R$ 100, ordenados por preço e ID.
2. Conte clientes por cidade.
3. Conte pedidos por status e explique quais entram na receita.
4. Liste clientes cadastrados que nunca compraram (nem pedido cancelado).

## Etapa 2 — relacionar e agregar
5. Liste os itens de um pedido com nome do produto e subtotal após desconto.
6. Calcule receita de produtos e frete separadamente, sem duplicar frete.
7. Encontre clientes sem pedidos concluídos. Compare com a questão 4.
8. Liste cinco produtos com maior receita líquida.
9. Calcule ticket médio por canal; explique o denominador.
10. Compare valor pago com valor dos itens mais frete.

## Etapa 3 — análise
11. Mostre receita mensal incluindo meses sem vendas e variação percentual.
12. Crie ranking de categorias com DENSE_RANK.
13. Mostre receita acumulada com SUM OVER.
14. Monte RFM em 15/01/2026. Explique recência, frequência e valor monetário.
15. Calcule coortes por mês da primeira compra e retenção no mês seguinte.
16. Calcule recompra e taxa de devolução por pedido e por unidade. Explique a diferença.

## Etapa 4 — banco de dados
17. Tente inserir item órfão, quantidade negativa e SKU duplicado. Explique os erros.
18. Execute a transação de atualização de preços e confirme o rollback.
19. Compare EXPLAIN antes e depois de um índice em uma base de teste maior.
20. Proponha um esquema de pagamentos divididos e estornos, sem alterar o histórico original.

## Etapa 5 — pós-graduação e portfólio
21. Exporte resultados para CSV e conecte ao Power BI ou Python.
22. Construa um painel com receita, ticket, recompra e devoluções, indicando o período e as definições.
23. Escreva uma análise de até uma página: evidência, hipótese, limitação e próximo teste.
24. Investigue os padrões artificiais do gerador. Explique por que eles não são evidência de comportamento real.

Critério de aprendizado: você deve explicar o grão, o JOIN, o filtro e o denominador de cada indicador. Uma consulta que executa sem erro pode ainda produzir uma métrica errada.
