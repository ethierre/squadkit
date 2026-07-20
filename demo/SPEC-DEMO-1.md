# SPEC-DEMO-1 — Calculadora de frete (task de demonstração)

> **Status:** aprovado (humano da demo, hoje)
> **Origem:** demo do SquadKit · **Sprint:** demo
> Task pequena e real o suficiente para ver a esteira inteira: pré-voo → implementação com
> testes → explain-back → review com evidência.

## Perguntas abertas (com recomendação do arquiteto)

Nenhuma — contrato fechado para a demo.

## 1. Objetivo e contexto

O e-commerce fictício "Frete Rápido" precisa de um módulo de cálculo de frete puro (sem
framework) para orçar entregas no checkout. Regras simples, mas com casos de borda reais.

## 2. Escopo

- Módulo `calcularFrete` em JavaScript puro (Node) + testes.

### Fora de escopo (explícito)

- Integração com transportadora, UI, persistência, moeda internacional.

## 3. Contratos ⭐

Função: `calcularFrete({ pesoKg, distanciaKm, expresso }) -> string` (valor em reais, 2 casas,
como STRING — dinheiro nunca é float).
Regras: base R$ 10,00 + R$ 1,50 por kg + R$ 0,20 por km; `expresso: true` multiplica o total
por 1,8; arredondamento só no resultado final.
Erros: `pesoKg <= 0` ou `> 30` lança `PesoInvalidoError`; `distanciaKm <= 0` lança
`DistanciaInvalidaError`. Entrada ausente = erro correspondente (nunca NaN silencioso).

## 4. Regras de negócio e casos de borda

Peso máximo transportável = 30 kg. Valores de entrada não são confiáveis (vêm do front).

## 5. Critérios de aceite (numerados — rastreabilidade CA-n → task → teste)

- **CA-1** · QUANDO receber `{pesoKg: 2, distanciaKm: 10, expresso: false}`, O SISTEMA DEVE
  retornar `"15.00"` (10 + 3 + 2).
- **CA-2** · QUANDO `expresso: true` no mesmo cenário, O SISTEMA DEVE retornar `"27.00"` (15 × 1,8).
- **CA-3** · QUANDO `pesoKg` for 0, negativo ou maior que 30, O SISTEMA DEVE lançar
  `PesoInvalidoError` (nunca retornar valor).

## 6. Plano de testes

Unitários por CA + bordas (peso 30 exato passa; 30,01 falha; distância 0 falha; ausência de campo).

## 7. Tasks técnicas (com ondas, complexidade e rédea)

| Task | Área | Agente | CAs cobertos | Depende de | Onda | Complexidade (1-10) | Rédea |
|---|---|---|---|---|---|---|---|
| T-DEMO-1 | back | squad-dev-back | CA-1, CA-2, CA-3 | — | 1 | 3 | supervisionada |

## 8. Componentes impactados

`src/frete.js` e `test/frete.test.js` (novos, nesta pasta do projeto demo).

## 9. Restrições não-funcionais

Zero dependências externas (Node puro, `node:test`).

## 10. Definição de pronto verificável ⭐

| Verificação | Comando | Resultado esperado |
|---|---|---|
| CA-1 e CA-2 (valores) | `node --test test/frete.test.js` | testes dos valores "15.00" e "27.00" verdes |
| CA-3 (erros de peso) | `node --test test/frete.test.js` | testes de PesoInvalidoError verdes |
| dinheiro como string | `node -e "console.log(typeof require('./src/frete.js').calcularFrete({pesoKg:2,distanciaKm:10,expresso:false}))"` | `string` |

## 11. Clarificações (log de sessões)

Sem sessões — demo.

## 12. Armadilhas conhecidas

Float de dinheiro (0.1+0.2 !== 0.3): calcule em centavos inteiros e formate no final.
