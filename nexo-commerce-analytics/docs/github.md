# Abrir no VS Code e publicar no GitHub

1. Extraia o ZIP; abra a pasta `nexo-commerce-analytics` em **Arquivo > Abrir Pasta** no VS Code.
2. Leia o README e execute `npm ci`, `npm test` e uma consulta.
3. Crie um repositório vazio no GitHub chamado `nexo-commerce-analytics`.
4. No terminal da pasta, execute:

```sh
git init
git add .
git commit -m "Initial relational SQL analytics project"
git branch -M main
```

5. Copie o endereço real do repositório na página do GitHub e substitua o marcador abaixo:

```sh
git remote add origin URL_DO_SEU_REPOSITORIO
git push -u origin main
```

Não use o marcador literalmente. Faça login pelo mecanismo do Git/GitHub; não coloque token em arquivo nem na conversa. O `.gitignore` exclui `.env`, dependências e dados locais.

Descrição sugerida do repositório: “Laboratório PostgreSQL de modelagem relacional e analytics: KPIs, RFM, coortes, integridade e testes com dados sintéticos.”

Próximos commits: solução própria de exercício, definição de indicador, novo teste, gráfico e explicação de uma decisão. Isso ajuda a demonstrar sua prática além da versão inicial assistida por IA.
