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

## 5. Critérios de aceite (numerados — rastreabilidade CA-n → task → teste)

- **CA-1** · **Dado** … **Quando** … **Então** …
- **CA-2** · (para requisito de comportamento contínuo, prefira formato EARS: "ENQUANTO/QUANDO
  [condição], O SISTEMA DEVE [comportamento mensurável]" — mecanicamente testável)

Regra: adjetivo vago ("rápido", "amigável") não é critério — quantifique ou corte. Todo CA deve
aparecer em ≥1 task (§7) e ≥1 verificação (§10); CA órfão = spec incompleta.

## 6. Plano de testes

<derivado do §5: unitários por task, contrato vs payloads do §3, regressão>

## 7. Tasks técnicas (com ondas, complexidade e rédea)

| Task | Área | Agente | CAs cobertos | Depende de | Onda | Complexidade (1-10) | Rédea |
|---|---|---|---|---|---|---|---|
| T-<id>-1 | back | squad-dev-back | CA-1, CA-2 | — | 1 | | supervisionada |
| T-<id>-2 | front | squad-dev-front | CA-3 | T-<id>-1 (o CONTRATO §3, não a implementação) | 1 | | supervisionada |

- **Onda** = tasks sem dependência entre si rodam EM PARALELO (onda 1); a onda N+1 só começa
  quando a N fecha. Derive as ondas do grafo de dependências, não de intuição.
- **Complexidade > 7 = fatiar ANTES de despachar** (o arquiteto quebra em sub-tasks aqui mesmo).
- **Rédea** (autonomia proporcional à consequência — método Karpathy):
  `assistida` = toca área irreversível/sensível (migração destrutiva, auth, pagamento, dado de
  cliente) → o dev entrega o PLANO primeiro e o humano aprova ANTES do código;
  `supervisionada` = padrão (spec → dev → review → gate humano no merge);
  `autônoma` = rotina de baixo risco já validada (regressão congelada, atualização por checklist)
  → roda direto, humano vê o relatório. Na dúvida, supervisionada.
- Branch única da entrega: `squad/<id>-<slug>`.

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

## 11. Clarificações (log de sessões)

_(respostas do humano às perguntas abertas são INTEGRADAS na seção certa acima E logadas aqui:
`### Sessão AAAA-MM-DD` · pergunta → resposta → seção atualizada. Default razoável assumido sem
perguntar vira registro em "Premissas assumidas" — auditável, não silencioso.)_

## 12. Armadilhas conhecidas

<testes existentes que podem quebrar (exigem liberação humana), ilhas fora de escopo, refs
defasadas nos cards, campos que o backend ainda não serve (→ empty-state), conflitos com branches abertas>
