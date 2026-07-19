# Pesquisa de mercado — ecossistemas de agentes de IA (jul/2026)

> Método: pesquisa web + **código clonado e lido** de 6 repositórios (OpenSquad, spec-kit,
> agent-os, contains-studio/agents, BMAD-METHOD v6, claude-task-master) + análise de 12 produtos
> comerciais. Resumo executivo do que moldou o SquadKit v0.5.0.

## Conclusão central

O mercado premium é forte na **disciplina a montante** (spec-kit: constituição→spec→plan→tasks→
analyze→converge com rastreabilidade FR→task) e na **experiência agêntica** (Antigravity: Agent
Manager + Artifacts; Kiro: SDD nativo com EARS e waves). **Nenhum player resolve confiança na
execução**: gates são instruções em prompt (o mesmo LLM cria e fiscaliza), sem evidência
executada obrigatória, sem anti-burla em código, sem evals. Esse é o fosso do SquadKit — a
v0.5.0 cobre o flanco a montante sem abrir mão dele.

## Players e o que absorvemos

| Fonte | O que tem de premium | O que absorvemos (v0.5.0) |
|---|---|---|
| **Google Antigravity** | Agent Manager (agentes paralelos), Artifacts verificáveis (walkthrough/screenshot/gravação), `.agents/` (agents.md+skills+workflows), AGENTS.md nativo | Adapter `.agents/workflows` + contrato de evidência com walkthrough |
| **AGENTS.md** (Linux Foundation) | Padrão de facto: 28+ ferramentas, 60k+ repos | AGENTS.md canônico instalado SEMPRE |
| **Amazon Kiro** | SDD nativo: requirements EARS + design + tasks; waves por grafo de deps; steering com inclusion modes | EARS nos critérios (CA-n); ondas de execução no SPEC §7 |
| **github/spec-kit** | Constituição SemVer + Sync Impact; clarify (máx 5 perguntas, respostas re-integradas); analyze (cobertura FR→task); converge (gaps: faltante/parcial/contradiz/**não-pedido**); checklists "unit tests for English" | Ciclo de vida do canon + protocolo de clarificação + rastreabilidade CA-n→task→teste + convergência com gap não-pedido |
| **BMAD-METHOD v6** | Story-file autossuficiente; checklists adversariais em contexto fresco; review em camadas cegas paralelas (TOML); Dev Agent Record c/ zonas de escrita | Camadas cegas de review + validador fresco |
| **claude-task-master** | Complexity scoring (1-10 + prompt de expansão); `next` por grafo; trio orchestrator/executor/checker; 16 profiles por CLI | Complexidade no SPEC §7 (>7 fatia antes); reforço do modelo "um conhecimento, N renderizações" |
| **contains-studio/agents** | Few-shot de roteamento na description; error-handling por cenário | "Quando me acionar" (✅/❌) no ROLE-TEMPLATE |
| **Devin** | Playbooks c/ success criteria + guardrails; knowledge org-wide | CAs mensuráveis obrigatórios (já tínhamos §10; formalizado) |
| **Replit Agent 3** | Test-subagent que clica no app (anti-"Potemkin UI"), ~$0,20/sessão | Contrato de evidência front = fluxo clicado; roadmap: QA browser-driven |
| **Cursor / Windsurf / Copilot / Factory** | Hooks com veto; planner dual-loop; agent profiles c/ allowlist de tools; model routing por fase | Roadmap (hooks-veto universais, routing por fase) |
| **agent-os** | discover→index→inject de standards (o "porquê" entrevistado); sync projeto→base | Roadmap (sync de conhecimento entre projetos) |
| **CrewAI / MetaGPT / AutoGen / LangGraph** | Role-based, SOPs, group-chat, checkpointing | Validam a tese; checkpointing no roadmap |

## Fraquezas do mercado que NÃO copiamos

Enforcement 100% em prompt (mesmo LLM cria e fiscaliza) · teatro de persona (cerimônia de ativação,
nomes fofos, caps-lock histérico) · "máquinas de estado" em pseudo-XML interpretadas pelo próprio
modelo · apagar rastro de revisão ("como se sempre estivesse lá" — anti-auditável) · deixar o LLM
inventar o backlog inteiro num tiro (parse-prd sem contratos) · zero testes da lógica-núcleo ·
prompt injection via browser sem quarentena.

## Nosso diferencial confirmado (defender a todo custo)

1. Evidência executada + anti-burla em CÓDIGO (hook), não em prompt.
2. Validadores determinísticos + evals golden (ninguém tem).
3. Fatos canônicos com evidência resolvendo contradições de docs (constituições têm princípios;
   ninguém tem FATOS com precedência).
4. Squad multi-papel real com dono único por artefato e roteamento tipado de bugs.
5. QA que EXECUTA (suítes reais), não inspeção estática por LLM.
6. Gate humano sobre evidência, não sobre prosa.

Fontes completas: relatórios internos da pesquisa (19/07/2026); URLs principais: antigravity.google,
kiro.dev/docs, agents.md, github/spec-kit, buildermethods/agent-os, contains-studio/agents,
bmad-code-org/BMAD-METHOD, eyaltoledano/claude-task-master, blog.replit.com, docs.devin.ai.
