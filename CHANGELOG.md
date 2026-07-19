# Changelog — SquadKit

## 0.4.0 — 2026-07-19 · Multi-CLI + contexto-primeiro + verificável em código

- **Multi-CLI/IDE**: core neutro em `core\` (fonte única) + adapters para Claude Code (skills,
  hook anti-burla, subagentes), Cursor (rules), Codex/OpenAI (AGENTS.md), VS Code Copilot
  (copilot-instructions) e genérico (`squad\INICIAR.md` — qualquer chat de IA).
- **`/montar-contexto`** (novo, o PRIMEIRO passo): entrevista + ingestão de docs + caça ativa a
  contradições → `_INDICE.md` com FATOS CANÔNICOS (com evidência) + `HISTORICO.md`.
- **Modelo é escolha do usuário**: papéis sem modelo fixo; `/montar-squad` sugere 3 por papel
  (desempenho/custo/custo-benefício via leaderboards) e registra em `squad\MODELOS.md`.
- **Validadores em código**: `validar-squad.ps1` (frontmatter, invariantes, placeholders, colisão
  de dono único, freio de ação irreversível) e `validar-spec.ps1` (§3/§5/§10 completas).
- **Evals golden** (`evals\`): bug plantado, spec ambígua, dado sem fonte — o harness testado
  como código.
- **`/fechar-sprint`** + `telemetria.csv` + `dashboard.ps1` (HTML de board+telemetria).
- **Best-practices com `whenToUse`** (`core\best-practices\`): modelos, spec-driven, evidência,
  revisão, análise de dados, conteúdo criativo — injetadas por papel no montar-squad.
- Novo domínio **pessoal/produtividade** + exemplo `squad-gestor-pessoal`.
- Instalador cross-platform (pwsh 7+ Win/macOS/Linux; compatível PS 5.1) com `-Ide` multi-valor.

## 0.3.0 — 2026-07-19 · Sob medida

- `/montar-squad` (descoberta → design com gate humano → build com gates BLOCKING), inspirado na
  análise de código do OpenSquad; `ROLE-TEMPLATE.md` com seções [INVARIANTE]; perfil `sob-medida`;
  catálogo+exemplos embarcados no projeto (`squad\_catalogo\`); exemplos youtube/pbm-farma/aidc7.

## 0.2.0 — 2026-07-19 · Composável

- Catálogo de 15 papéis + `perfis.json` (7 presets) + instalador `-Perfil`/`-Papeis`;
  esteira adaptativa com fallbacks por papel ausente; fase de concepção (BRIEF→PRD→HISTORIAS→UX).

## 0.1.0 — 2026-07-19 · Fundação

- Esqueleto extraído do squad 7Risk validado em produção (piloto FE-17): esteira spec-driven,
  memória de sprint em arquivos com dono único, hook anti-burla de testes, gates humanos.
