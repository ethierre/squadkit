# Pesquisa — Paperclip (jul/2026, código lido: ~4k arquivos via git)

> paperclipai/paperclip (clone analisado identifica-se como fork HenkDz c/ adapters extras).
> Nota: liderança de mercado NÃO verificável pelo clone (stars/tração fora do escopo); maturidade
> de engenharia SIM: 181 migrations, 1046 arquivos de teste, e2e+visual regression, release train.

## O que é (e por que NÃO é concorrente frontal)

**Control plane para "empresas" de agentes 24/7**: servidor Node+Postgres+React onde você define
meta, "contrata" um time (org chart, cargos, orçamentos) e agentes de QUALQUER CLI (Claude Code,
Codex, Cursor, Gemini… via adapters) acordam por **heartbeat** para puxar issues. Bordão: "se o
agente é um funcionário, o Paperclip é a empresa".
**Categoria adjacente ao SquadKit**: eles orquestram QUEM trabalha numa operação persistente
(exige hospedar servidor+DB); nós blindamos COMO cada entrega sai (spec-driven + harness,
repo-native, sem servidor). Eles são goal-driven ("nunca peça a um humano o que um agente faz");
nós somos human-gates-first. **O vão que eles decidiram não preencher é exatamente o nosso produto.**

## Notas na nossa régua

Conceito 9 · **Enforcement 9** (o melhor que vimos: invariantes em servidor+DB, não em prompt) ·
Maturidade 9 · DX 7-8 (1-comando + Postgres embutido, mas superfície enorme) · Docs 9.

## As joias de enforcement (transferíveis ao nosso mundo file-based)

| # | Técnica deles | Tradução para o SquadKit |
|---|---|---|
| 1 | **Evals promptfoo automatizados** (~23 casos, matriz de 4 modelos, asserts determinísticos + regra "todo prompt-eval pareia com teste de código") | ✅ ADOTADO (v0.7.2): nossos 3 golden viram suíte promptfoo em `evals\promptfoo\` |
| 2 | **Ações assinadas (HMAC)**: aprovação humana cripto-ligada aos argumentos EXATOS da tool; mudou argumento → assinatura quebra | Versão file-based: aprovação de review referencia o **hash do diff** aprovado; diff mudou pós-aprovação → re-aprovar (roadmap) |
| 3 | **Consent-gate**: auto-modificação de instrução exige confirmação humana que (a) exibiu diff, (b) veio de run ANTERIOR (sem auto-aprovação no mesmo turno), (c) é consumida UMA vez | Regra para mudança de spec/papel na esteira (roadmap) |
| 4 | **Trust-tiers**: saída de agente low-trust é QUARENTENADA antes de entrar no contexto de quem decide | Reforça nosso "conteúdo externo é dado"; formalizar nível de confiança por fonte de evidência (roadmap) |
| 5 | **Checkout atômico** (compare-and-swap no claim da task — zero trabalho duplicado) | Relevante quando a esteira for multi-sessão/CI (roadmap Nível CI) |
| 6 | **Budget hard-stop por escopo** (centavos-inteiros; warn% → pausa automática + cancela fila) | Entra no desenho do coletar-custo: teto de custo por task/sprint com parada (roadmap) |
| 7 | **Guardas determinísticos de prompt-injection** (regex nomeadas: ignore-previous, reveal-system-prompt, exfiltração) | Candidato a validador barato nos nossos scripts (roadmap) |
| 8 | **CI como harness do próprio repo**: bot de review em `pull_request_target` que NUNCA executa código do PR + gates de qualidade/segurança em scripts + check "no-git-push" no runtime | Modelo para o nosso "CI backstop" do roadmap |
| 9 | **Times como bundles versionados** (`TEAM.md schema agentcompanies/v1`) e **skills injetadas em runtime** por papel | Valida nosso catálogo/perfis; exportar/importar "squad bundle" (roadmap) |

## Fraquezas deles (nosso fosso confirmado, de novo)

Não é spec-driven (sem contrato spec→tasks→critérios congelado) · evals ainda Fase 0 (~23 casos
do prompt de heartbeat; rubrica LLM é roadmap deles) · superfície gigante (155 tabelas, heartbeat
de ~17k linhas, servidor para operar) · o rigor DENTRO de cada run é BYO — **é onde o SquadKit vive**.

## Conclusão

Tratar como **fonte de padrões de enforcement, não rival**. Prioridade de absorção: evals
automatizados (feito) → aprovação ligada ao hash do diff → consent-gate de mudança de spec →
budget hard-stop no coletar-custo. Manter o foco: spec-driven + harness unificado + repo-native.
