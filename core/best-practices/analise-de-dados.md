# Análise de dados — método para papéis analíticos (vendas, métricas, relatórios)

## Antes de analisar

- Exija a spec do pedido: **objetivo + período + recorte + fonte**. Sem isso, devolva pedindo.
- Conheça o dicionário de dados (fatos canônicos do projeto): o que cada coluna significa, moeda,
  fuso, granularidade. Suposição de significado é a mãe das análises erradas.

## Método

1. **Sanidade primeiro**: totais batem com a fonte? período completo? duplicatas? nulos relevantes?
   Registre as conferências COM os valores (evidência executada).
2. **Comparativos honestos**: vs período anterior, vs mesma janela do ano anterior (sazonalidade),
   vs meta. Variação sem base de comparação não é leitura.
3. **Decomponha antes de concluir**: total → recortes (região/loja/produto/canal). O agregado
   esconde; o recorte revela.
4. **Hipótese ≠ conclusão**: "caiu 12% (fato) — possivelmente pela ruptura de estoque (hipótese,
   verificar com X)". Rotule cada um.
5. **Recomendações amarradas ao dado**: cada recomendação cita o número que a sustenta e o que
   monitorar para saber se funcionou.

## Regras

- Base incompleta/suja = declarar a limitação ANTES da leitura; nunca extrapolar em silêncio.
- Projeção só com premissas explícitas.
- Reproduzibilidade: consulta/fórmula/passos anexados — outra pessoa refaz e chega no mesmo número.
- Privacidade: dado pessoal identificado NUNCA em relatório — só agregados (LGPD).
