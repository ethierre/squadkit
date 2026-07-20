# Pesquisa — hooks com veto por IDE + QA browser anti-Potemkin (jul/2026)

## Tema 1 — hooks com VETO (matriz)

| IDE | Mecanismo | Veta o quê | Formato | Config |
|---|---|---|---|---|
| Claude Code | Hooks (30+ eventos; `PermissionRequest` novo; matcher com `if` estilo permission-rule → **veto por PATH nativo**: `"Edit(*.ts)"`) | qualquer tool, prompt, Stop | exit 2 ou JSON `permissionDecision` (+ `updatedInput`) | `.claude/settings.json` |
| **VS Code/Copilot** | Agent Hooks (Preview) — **LÊ O FORMATO DO CLAUDE CODE** (`.claude/settings.json`!) | tool call | `permissionDecision: deny` / exit 2 | `.claude/settings.json` ou `.github/hooks/` (matchers ignorados — filtrar no script) |
| Cursor | Hooks beta (1.7+): `preToolUse`, `beforeShellExecution` (pre-commit = interceptar `git commit`), `beforeReadFile` | shell, MCP, leitura, prompt | JSON `permission: allow/deny/ask` (default fail-OPEN — setar `failClosed`) | `.cursor/hooks.json` |
| Antigravity 2.0 | Hooks (I/O 2026): pré/pós tool e model call; **pode bloquear a PARADA do agente** ("não pare sem rodar testes") | tool, model, stop | JSON `decision: allow/deny/ask` (sempre exit 0; CLI usa `allow_tool`) | `.agents/hooks.json` |
| Windsurf | Cascade Hooks — **EOL 01/07/2026** (→ Devin Desktop); não investir | — | — | — |
| Git (universal) | pre-commit — **contornável** (`--no-verify` documentado em caso real: agente burlou 6 commits apesar de regras) | commit | exit ≠ 0 | `.git/hooks` |

**Conclusão de arquitetura (defesa em camadas):** regra em prompt = documentação · deny-rules =
pega o óbvio · **hook do IDE parseando o comando inteiro** (detectar `--no-verify`, `core.hooksPath`)
= veto real dentro do IDE · **PATH-shim de git** = única defesa universal por fora ·
**CI como backstop** (roda os checks no push; agente não passa `--no-verify` no pipeline).
Nosso hook git atual é UMA camada — o roadmap ganha as outras.

## Tema 2 — QA browser anti-Potemkin (desenho pronto p/ implementar)

**Engine universal: Playwright MCP** (microsoft/playwright-mcp, 35k⭐): opera pela árvore de
acessibilidade (determinístico, sem visão), instala em Claude Code/Cursor/VS Code/Antigravity;
snapshot+click+type+network+console+screenshot+trace+vídeo. Bônus: **Playwright Test Agents**
(planner/generator/healer — `npx playwright init-agents`) já empacotam o padrão
"plano → teste congelado → auto-conserto".

**Arquitetura do papel `squad-qa-browser`** (referências: Replit US$0,20/sessão mediana; Antigravity
artifacts nativos):
1. **Roteiro derivado dos CA-n** do SPEC → `specs/QA-<id>.md` (um bloco por CA, passos + esperado).
2. **Dois modos**: exploração (passo a passo via MCP, 1ª vez) → **regressão** (fluxo verde congela
   como script Playwright commitado; healer conserta seletor — ~10x mais barato nas rodadas seguintes).
3. **Contrato de evidência** (o anti-Potemkin de verdade): screenshot por passo (`CA<n>-passo<k>.png`),
   trace/vídeo, console errors, requests com status; `EVIDENCIAS-<id>.md` com veredito POR CA
   linkando os arquivos. **CA sem arquivo de evidência = não testado** (hook Stop pode bloquear o
   encerramento sem os arquivos existirem).
4. **Custo estimado**: US$0,15–0,60/sessão exploração; centavos em regressão. Evitar computer-use
   por visão (~US$0,50/micro-fluxo).
5. **Riscos**: flakiness (auto-wait, `--isolated`, retries), seletores (refs por snapshot; scripts
   congelados usam `getByRole`/`getByTestId`), token bloat (rodar como SUBAGENTE devolvendo só
   sumário — padrão Replit), auth/2FA (storageState pré-autenticado — nunca o agente "se virar"
   no login), QA-Potemkin (o próprio QA fingir — evidência em arquivos verificáveis).

Fontes: github.com/microsoft/playwright-mcp · playwright.dev/docs/test-agents ·
replit.com/blog/automated-self-testing · code.claude.com/docs/en/hooks · cursor.com/docs/hooks ·
antigravity.google/docs/hooks · pydevtools.com (anti-bypass) · issue claude-code#40117.
