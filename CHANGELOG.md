# Changelog — SquadKit

## 0.6.0 — 2026-07-19 · Harness a montante: rastreabilidade, hook universal, onboarding e 5 best-practices

- **Validador de rastreabilidade em código** (`validar-spec.ps1` v2): cobertura CA→task→verificação
  determinística sobre as chaves CA-n — CA sem task = reprovado; task citando CA inexistente =
  reprovado; CA sem verificação no §10 = aviso; imprime cobertura X/Y. (A versão determinística do
  `/analyze` do spec-kit.)
- **Hook anti-burla UNIVERSAL** (`instalar-hook-git.ps1`): git pre-commit que bloqueia commit
  modificando teste rastreado (allowlist humana respeitada; teste novo passa) — vale para QUALQUER
  IDE/CLI, não só Claude Code. Testado ponta a ponta.
- **Onboarding guiado** (`instalar-squad.ps1 -Interativo`): 6 perguntas em linguagem simples no
  lugar de flags — para usuário não-técnico (vida pessoal, vendas, conteúdo).
- **Gate de qualidade de spec na esteira**: antes do gate humano, o arquiteto gera o checklist da
  ESCRITA (`qualidade-de-spec.md` — "unit tests for English", ≥80% itens com rastreabilidade) e
  roda o validador — o humano recebe spec auditada, não rascunho.
- **+5 best-practices** (catálogo whenToUse, total 11): migração de banco, segurança de API
  (P0/P1), SEO/YouTube, finanças/planilhas pessoais, qualidade de spec.

## 0.5.1 — 2026-07-19 · Correções do primeiro teste de usuário em projeto real

- **fix:** `validar-squad.ps1` e `dashboard.ps1` derivam a raiz da PRÓPRIA localização
  (`<raiz>\squad\scripts\`) em vez do diretório atual — rodar de outro cwd validava o squad
  errado (bug reportado em instalação real); ambos imprimem a raiz em uso.
- **novo:** `atualizar-squad.ps1` — sincroniza `_core` + scripts + catálogo de instalações
  existentes (manifesto `squad/.squadkit.json`, gravado pelo instalador; instalações antigas
  aceitam os parâmetros via flags). Nunca toca contexto, equipe, board ou adapters.
- **novo:** `montar-contexto` termina com **📋 Resumo de Entendimento** obrigatório (o que é o
  projeto, inventário de leitura, fatos canônicos, decisões, contradições, riscos, perguntas) +
  loop de confirmação — correção do usuário sobrescreve inferência.

## 0.5.0 — 2026-07-19 · Antigravity + padrão AGENTS.md + upgrades da pesquisa de mercado

- **Google Antigravity** suportado (`-Ide antigravity`): `.agents/workflows/` (montar-contexto,
  montar-squad, squad, fechar-sprint como slash-workflows) + `.agents/agents.md`; Artifacts do
  Antigravity mapeados ao contrato de evidência.
- **AGENTS.md canônico instalado SEMPRE** (padrão agents.md / Linux Foundation — lido por Codex,
  Antigravity, Copilot, Windsurf, Devin e 25+ ferramentas).
- **Pesquisa de mercado** (6 repos clonados + 12 produtos): `docs/PESQUISA-MERCADO-2026-07.md`.
- SPEC upgrades: critérios **CA-n numerados** (rastreabilidade CA→task→teste) com formato **EARS**;
  §7 com **ondas de execução** (grafo de deps → paralelismo) e **complexidade 1-10** (>7 fatia
  antes); §11 log de clarificações.
- **Protocolo de clarificação** (máx 5 perguntas, múltipla-escolha com recomendação, respostas
  re-integradas na spec; defaults viram premissas auditáveis).
- Review: **camadas cegas paralelas** (adversarial/borda/gap-de-verificação/auditor de aceitação),
  **convergência com gap `não-pedido`** (pega scope creep) e severidade calibrada (só P0/P1 bloqueia).
- **Contrato de evidência por tipo de entrega** (front = fluxo clicado/screenshot — anti-"Potemkin UI").
- **Ciclo de vida do canon**: mudança de fato canônico gera relatório de impacto; "conflito se
  resolve corrigindo a spec, nunca diluindo o canon".
- ROLE-TEMPLATE: seção "Quando me acionar" (few-shot ✅/❌ de roteamento) — exigida no build.

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
