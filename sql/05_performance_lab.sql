-- Compare planos; nesta base pequena o PostgreSQL pode preferir leitura sequencial.
EXPLAIN (ANALYZE,BUFFERS)
SELECT order_id,ordered_at FROM commerce.orders
WHERE customer_id=42 AND ordered_at>=DATE '2025-06-01' ORDER BY ordered_at;
-- A versão sem função na coluna favorece índices de data.
EXPLAIN (ANALYZE,BUFFERS)
SELECT * FROM commerce.orders WHERE ordered_at>=DATE '2025-06-01' AND ordered_at<DATE '2025-07-01';
-- Desafio: gere mais pedidos em uma base separada, compare seletividade e tamanho do índice.
