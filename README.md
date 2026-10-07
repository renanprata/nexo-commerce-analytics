# Nexo Commerce Analytics

Projeto educacional de SQL e banco de dados relacional para portfólio de **Renan Pratavieira Santos**. Empresa e dados inteiramente fictícios. Versão inicial desenvolvida com assistência de IA; a evolução e a interpretação das análises fazem parte do aprendizado.

## Problema de negócio
Uma loja vende em três canais e precisa acompanhar receita, margem de contribuição dos produtos, recompra e devoluções. O projeto separa dados transacionais de consultas analíticas e evita duplicar valores em JOINs.

## O que está implementado
- 7 tabelas relacionais, chaves primárias/estrangeiras, índices e restrições.
- 240 clientes, 40 produtos, 1.800 pedidos e 3.600 itens; datas de janeiro a dezembro de 2025.
- Preços e custos históricos por item, pagamentos e devoluções parciais.
- 3 views analíticas e 10 consultas: KPIs, crescimento, ranking, RFM, coortes, recompra e reconciliação.
- Laboratórios de transação e plano de execução; testes automatizados e workflow GitHub Actions.
- [Modelo e dicionário](docs/model.md), [exercícios](docs/exercises.md) e [guia para GitHub](docs/github.md).

## Comece sem Docker
Instale Node.js 22 ou posterior e abra esta pasta no VS Code. No terminal:

```sh
npm ci
npm test
npm run query -- sql/queries/01_monthly_growth.sql
```

Este caminho usa **PGlite**, um PostgreSQL embarcado em WebAssembly. Cada execução cria uma base temporária limpa; não salva alterações. É útil para começar e validar SQL. Não substitui testes de servidor, concorrência ou operação de produção.

## PostgreSQL local persistente com Docker
Instale Docker Desktop. Copie `.env.example` para `.env` e troque a senha. No PowerShell:

```powershell
Copy-Item .env.example .env
docker compose up -d
```

Conecte o SQLTools do VS Code ou o DBeaver: host `localhost`, porta `5433`, banco `nexo`, usuário `student`, senha definida em `.env`. Execute os arquivos de `sql/queries` nessa conexão.

Alternativamente, abra o terminal SQL:

```sh
docker compose exec db psql -U student -d nexo
```

Os três scripts iniciais rodam somente quando o volume está vazio. Não execute o schema novamente sobre uma base já criada. `docker compose down` mantém os dados. Para reiniciar **apagando apenas os dados deste laboratório**, use `docker compose down -v` e depois `docker compose up -d`.

## Organização

| Pasta/arquivo | Finalidade |
|---|---|
| sql/01_schema.sql | Estrutura, regras e índices |
| sql/02_seed.sql | Geração determinística de dados fictícios |
| sql/03_analytics.sql | Views por item, pedido e mês |
| sql/queries/ | Consultas comentadas |
| sql/04_transaction_lab.sql | BEGIN, SAVEPOINT e ROLLBACK |
| sql/05_performance_lab.sql | EXPLAIN ANALYZE |
| tests/check.mjs | Validação de integridade e análises |
| docs/sample-results.json | Resultado gerado na verificação |

## Definições e limites
Receita líquida neste laboratório = valor dos produtos menos descontos e reembolsos, atribuído ao mês do pedido original. Frete é separado. Não é uma demonstração contábil: não modela impostos, taxas de plataforma, despesas operacionais ou reconhecimento por data de devolução.

A contribuição dos produtos deduz o custo das unidades mantidas pelo cliente. Assume que as unidades devolvidas recuperam integralmente seu custo. Não equivale a lucro líquido.

Somente pedidos `completed` entram nas análises. Um pagamento representa o valor original do pedido e não é reduzido por devoluções. Não há pagamentos divididos, registro de estorno financeiro, estoque, usuários de aplicação ou fluxo de finalização de pedidos. Essas são evoluções possíveis, não funcionalidades já implementadas.

O gerador é determinístico e artificial: padrões de frequência, canais e produtos não representam um mercado real. As consultas RFM e coortes servem para aprender método; não sustentam conclusões comerciais reais.

## Como apresentar
Explique primeiro o problema, o grão de cada tabela e as regras. Depois demonstre uma consulta com JOIN, uma com função de janela, a reconciliação e um teste que rejeita um dado inválido. Acrescente suas próprias consultas e registre decisões no GitHub. Não declare experiência profissional ou autoria independente que o projeto não demonstre.

## Referências
- [PostgreSQL: SQL](https://www.postgresql.org/docs/17/sql.html)
- [PostgreSQL: transações](https://www.postgresql.org/docs/17/tutorial-transactions.html)
- [PGlite](https://pglite.dev/docs/)

Licença MIT. Não contém dados pessoais reais nem credenciais de produção.
