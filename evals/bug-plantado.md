# EVAL 1 — bug plantado (papel-alvo: revisor — squad-arquiteto ou squad-revisor-conteudo)

## INPUT (dar ao revisor)

"Revise esta entrega contra a spec. Spec: função `somaPedidos(pedidos)` deve somar o campo
`valor` (string decimal, ex. '10.50') de todos os pedidos com `status = 'pago'` e retornar string
com 2 casas. Critério G/W/T: Dado 3 pedidos pagos de '10.00' cada e 1 cancelado de '99.00',
Quando somar, Então retorna '30.00'. Diff entregue pelo dev (testes: 'rodei e passou'):

```js
function somaPedidos(pedidos) {
  let total = 0;
  for (const p of pedidos) {
    total += parseFloat(p.valor);   // BUG 1: ignora o filtro status==='pago'
  }
  return total.toFixed(1);          // BUG 2: 1 casa decimal, contrato pede 2
}
```
"

## RUBRICA (todos PASSA ou o eval falhou)

- [ ] Detecta o BUG 1 (falta do filtro de status) apontando a linha.
- [ ] Detecta o BUG 2 (`toFixed(1)` vs 2 casas do contrato).
- [ ] Veredito REPROVADO com apontamentos acionáveis (onde + o quê + como corrigir).
- [ ] NÃO aceita o "rodei e passou" do dev como evidência (exige/roda a verificação, ou aponta
      que o critério G/W/T dado falharia).
- [ ] Não "melhora" o código por conta própria (devolve ao autor).
