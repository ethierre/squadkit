# SPEC-<id> — <título curto>

> **Status:** rascunho | **aprovado** (<humano>, <data>)
> **Origem:** <história/card no board {{BOARD}}> · **Sprint:** <n>
> Escrito por squad-arquiteto. O contrato daqui é a definição de pronto — divergência é defeito,
> não interpretação.

## Perguntas abertas (com recomendação do arquiteto)

_(numeradas; no modo "executar" não travam a esteira — o dev segue a recomendação)_

## 1. Objetivo e contexto

<1–3 parágrafos: o problema de negócio>

## 2. Escopo

- <o que entra>

### Fora de escopo (explícito)

- <o que NÃO entra — evita que o agente "melhore" o que não foi pedido>

## 3. Contratos ⭐

<payloads de entrada/saída (JSON exemplo + regras), endpoints, DDL. Contrato já congelado do
projeto = referenciar (documento + seção + campos consumidos), não recopiar.>

## 4. Regras de negócio e casos de borda

## 5. Critérios de aceite (Given/When/Then)

- **Dado** … **Quando** … **Então** …

## 6. Plano de testes

<derivado do §5: unitários por task, contrato vs payloads do §3, regressão>

## 7. Tasks técnicas

| Task | Área | Repo | Agente | Branch | Depende de |
|---|---|---|---|---|---|
| T-<id>-1 | back | <repo> | squad-dev-back | squad/<id>-<slug> | — |
| T-<id>-2 | front | <repo> | squad-dev-front | squad/<id>-<slug> | T-<id>-1 (o CONTRATO §3, não a implementação) |

## 8. Componentes impactados

<repos, módulos, tabelas, endpoints>

## 9. Restrições não-funcionais

<performance, segurança, privacidade/LGPD — herdar de DECISOES.md e dos fatos canônicos>

## 10. Definição de pronto verificável ⭐

| Verificação | Comando | Resultado esperado |
|---|---|---|
| <ex.: testes unitários> | <comando exato no repo> | <saída esperada> |
| <ex.: build> | <comando> | <saída esperada> |
| <ex.: ausência de mock/regressão> | <grep/verificação objetiva> | <esperado> |

## 11. Armadilhas conhecidas

<testes existentes que podem quebrar (exigem liberação humana), ilhas fora de escopo, refs
defasadas nos cards, campos que o backend ainda não serve (→ empty-state), conflitos com branches abertas>
