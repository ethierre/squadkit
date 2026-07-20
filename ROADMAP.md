# Roadmap — SquadKit

> Atualizado 2026-07-19 (v0.7.1, pós-auditoria adversarial). Tese: **prompt de agente é commodity;
> o fosso é contexto curado + enforcement externo + evals.**

## ✅ ENTREGUE

**v0.4.0** — multi-CLI (core neutro + adapters claude/cursor/codex/vscode/genérico) ·
`/montar-contexto` (caça-contradições → fatos canônicos) · `/montar-squad` + `/fechar-sprint` ·
validadores `validar-squad`/`validar-spec` · evals golden (3 cenários) · telemetria + dashboard ·
modelo = escolha do usuário (3 sugestões via leaderboards) · best-practices com `whenToUse`
(6 docs à época; hoje 13) · domínio pessoal · repo GitHub + instalador pwsh.

**v0.5.x** — Google Antigravity (workflows + agents.md) · AGENTS.md canônico sempre · CA-n/EARS +
ondas + complexidade no SPEC · protocolo de clarificação · camadas cegas + convergência
(`não-pedido`) + P0/P1 · contrato de evidência por tipo (anti-Potemkin) · ciclo de vida do canon ·
Resumo de Entendimento no montar-contexto · `atualizar-squad.ps1` + manifesto · scripts auto-raiz ·
dossiê `docs/PESQUISA-MERCADO-2026-07.md`.

**v0.6.x** — validador de rastreabilidade CA→task→verificação em código · hook anti-burla
universal (git pre-commit) · onboarding `-Interativo` · checklist "unit tests for English" como
gate · +6 best-practices (banco, segurança de API, SEO/YouTube, finanças pessoais, qualidade de
spec, **design-distintivo** anti-template de IA) · método Karpathy como pré-voo
(`engenharia-agentica.md`) · papel `squad-qa-browser` · dossiês de telemetria e hooks/QA-browser.

**v0.7.x** — rédea por task (assistida/supervisionada/autônoma) · orçamento de diff
(`validar-diff.ps1` + `diffMaximo`) · explain-back obrigatório · guardas de git anti-`--no-verify`
em 3 IDEs · modo demo de 5 minutos · **checkup adversarial completo** (HISTORICO unificado, hooks
cross-platform via `{{PWSH}}`, contagens corrigidas, glossário e pré-requisitos no README,
enforcement em 3 camadas documentado).

## PRÓXIMO (v0.8+ — em ordem de valor)

1. **`coletar-custo.ps1`** no fechar-sprint — desenho pronto no
   [dossiê de telemetria](docs/PESQUISA-TELEMETRIA-CUSTO-2026-07.md): Claude Code por task (JSON
   headless + transcript), ccusage p/ Codex/Gemini/Copilot, colunas `fonte`/`billing_mode`.
2. **Guia de setup Playwright MCP por IDE** para o `squad-qa-browser` + hook Stop que bloqueia
   encerrar o QA sem os arquivos de evidência ([dossiê](docs/PESQUISA-HOOKS-QA-BROWSER-2026-07.md)).
3. **Rédea automática sugerida** — o arquiteto propõe a rédea por heurística (toca
   migração/auth/pagamento → assistida) e o humano confirma no gate do SDD.
4. **Sync de conhecimento entre projetos** (padrão agent-os) — standards/lições de um squad voltam
   para uma base herdável.
5. **Automatizar os evals** — script que dispara os 3 cenários numa sessão headless e confere a
   rubrica (CI: papel alterado → evals verdes ou MR bloqueado).
6. **Nível CI — esteira como pipeline** (GitLab/GitHub Actions): label na issue dispara o agente
   headless; N demandas em paralelo, auditável.
7. **PATH-shim de git** (camada anti-bypass extra universal) + CI backstop de exemplo.
8. **Expor SquadKit como MCP server** — board, specs e telemetria como tools para qualquer CLI.

## VISÃO (3+ meses)

- Agent SDK / Managed Agents com o SDD como rubrica de *Outcome* (o harness itera até a entrega
  satisfazer a spec).
- Biblioteca comunitária de papéis/squads (contribuição via PR com evals obrigatórios).
- De ferramenta interna a produto — cases: fintech (7Risk), IDP (AIDC7), gestão (APPAI), conteúdo
  (YouTube), operações (PBM).

## O que NÃO fazer

- Motor de orquestração próprio (a CLI do usuário é o runtime — OpenSquad prova que engine não é o valor).
- Papéis novos sem demanda real (o sob-medida cobre).
- Composição/execução sem gate humano (aprovação de design/PRD/merge é feature, não atrito).
- Enforcement por prompt onde couber código (hook/script primeiro; prompt é a última linha).
- Rankings de modelo hardcoded (mudam todo mês — sempre apontar para leaderboards vivos).
