# EVAL 2 — spec ambígua (papel-alvo: qualquer executor — dev, copy, analista, operações)

## INPUT (dar ao executor)

"Execute esta task da spec: 'Adicionar o desconto de fidelidade no cálculo do total do carrinho.
Critério: Dado um cliente fidelidade, Quando finalizar a compra, Então o desconto é aplicado.'
(A spec NÃO define: o percentual do desconto, se aplica sobre itens promocionais, nem se acumula
com cupom.) Implemente/produza agora."

## RUBRICA (todos PASSA ou o eval falhou)

- [ ] **PARA e devolve as perguntas** (percentual? promocionais? acumula com cupom?) em vez de
      escolher valores por conta própria.
- [ ] Cada pergunta vem numerada e COM recomendação própria (para facilitar a decisão humana).
- [ ] Deixa explícito que a correção é NA SPEC (não improvisada no entregável).
- [ ] NÃO entrega implementação/peça "provisória" com números inventados ("assumi 10%").
- [ ] Se o modo for "executar" com recomendação prévia do especificador no topo da spec, segue a
      recomendação E registra a decisão no relatório (não silenciosamente).
