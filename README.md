# SquadKit — squads de agentes IA que se moldam ao seu projeto

Monte um **time de papéis de IA sob medida** — de dev sênior/arquiteto a copy de YouTube, de
análise de vendas a agenda pessoal — operando numa esteira **spec-driven** com **harness
engineering** (evidência executada, anti-burla, gates humanos). Funciona na **IA que você já usa**:
Claude Code, Cursor, **Google Antigravity**, Codex/OpenAI, VS Code Copilot, DeepSeek ou qualquer
chat — com **AGENTS.md** (padrão Linux Foundation, 28+ ferramentas) instalado sempre como camada
canônica.

Validado em produção (piloto 7Risk/7Comm, jul/2026) e calibrado por **pesquisa de mercado com
código na mão** — 6 repositórios clonados e analisados (OpenSquad, github/spec-kit, agent-os,
contains-studio/agents, BMAD-METHOD, task-master) + 12 produtos comerciais (Antigravity, Kiro,
Cursor, Devin, Factory, Replit…): ver [docs/PESQUISA-MERCADO-2026-07.md](docs/PESQUISA-MERCADO-2026-07.md).
Conclusão da pesquisa: o mercado é forte a montante (spec/rastreabilidade), mas **ninguém resolve
confiança na execução** — evidência executada, anti-burla em código e evals são o fosso deste produto.

## Comece aqui (3 passos)

```powershell
# 1. Instale na pasta do seu projeto (pwsh = PowerShell 7+, funciona em Win/macOS/Linux)
pwsh -File instalar-squad.ps1 -Projeto "MeuProjeto" -Destino "C:\meuprojeto" `
     -Perfil sob-medida -Ide claude,antigravity   # claude · cursor · antigravity · codex · vscode · generico

# 2. Abra sua IA na pasta e rode:  /montar-contexto   ← SEMPRE primeiro
#    (entrevista + ingestão dos seus docs + caça a contradições → fatos canônicos)

# 3. Depois:  /montar-squad
#    (o time se molda ao contexto; você aprova a composição E escolhe os modelos)
```

Outra IA sem integração? `squad\INICIAR.md` — cole na conversa e funciona.

## Os 3 pilares (o que este produto tem que prompts soltos não têm)

1. **Spec-driven** — nenhum entregável sem spec (código←SDD, tela←SPEC-UX, campanha←BRIEF,
   análise←pedido estruturado, rotina←checklist). Ambiguidade PARA e pergunta — nunca inventa.
2. **Harness engineering** — evidência executada (saída real colada, "binário não alucina"),
   anti-burla (teste/golden/checklist não se enfraquece para passar — com hook externo no Claude
   Code), dono único por artefato, honestidade de dado (sem fonte = hipótese rotulada/empty-state),
   ação irreversível (publicar/enviar/pagar/mergear/aplicar) é SEMPRE do humano.
3. **Verificável em código** — validadores determinísticos (`squad\scripts\validar-squad.ps1`,
   `validar-spec.ps1`), evals golden (`evals\` — bug plantado, spec ambígua, dado sem fonte),
   telemetria (`squad\telemetria.csv`) e dashboard (`squad\scripts\dashboard.ps1` → HTML).

## Modelos de IA: VOCÊ escolhe

Nenhum papel impõe modelo. O `/montar-squad` sugere **3 opções por papel** (🏆 desempenho ·
💰 custo · ⚖️ custo-benefício) com base em leaderboards vivos
([lmarena.ai](https://lmarena.ai/leaderboard), [artificialanalysis.ai](https://artificialanalysis.ai))
— e você decide, inclusive fora das sugestões. Registro em `squad\MODELOS.md`.
Guia: `core\best-practices\escolher-modelos.md`.

## O que vem na caixa

```
core\orquestracao\      montar-contexto · montar-squad · esteira · fechar-sprint  (fonte única, qualquer IDE)
core\best-practices\    catálogo com whenToUse (RAG barato): modelos, spec-driven, evidência,
                        revisão, análise de dados, conteúdo criativo
roles\                  15 papéis prontos + ROLE-TEMPLATE.md (meta-template c/ invariantes de harness)
exemplos\               squads reais: youtube (copy/revisor/media/tráfego) · pbm-farma (vendas/operações)
                        · aidc7 (especialista OCR) · pessoal (gestor de agenda/rotinas)
adapters\               claude-code (skills+hook) · cursor · codex · vscode · generico
scripts\                validar-squad · validar-spec · dashboard
evals\                  3 cenários golden do comportamento de harness
squad\                  memória compartilhada: SPRINT (board) · DECISOES · BUGS · MODELOS ·
                        telemetria.csv · specs\ · contexto\
perfis.json             presets: sob-medida ⭐ · enxuto · dev-completo · produto · plataforma ·
                        concepcao · growth · completo
```

## Papéis prontos (15) — e infinitos sob medida

analista · pm · po · gerente · **arquiteto** (especifica E revisa — o único obrigatório) · ux ·
dev-front · dev-back · dev-dados · dev-mobile · qa · devops · seguranca · marketing · docs.
Precisa de "gestor de tráfego", "especialista OCR", "operações PBM"? O `/montar-squad` gera do
`ROLE-TEMPLATE.md` mantendo os invariantes — os exemplos mostram o resultado.

## Como funciona no dia a dia

- **Um único chat = o orquestrador.** Papéis rodam como subagentes (Claude Code) ou por troca de
  persona (demais IDEs) — handoff via arquivos, cada artefato com um dono.
- `montar-contexto` → `montar-squad` → operação: `/<slug>-squad US<n>` (esteira completa),
  `executar <task>` (curto), `bug <desc>` (triagem) → `fechar-sprint` (telemetria + memória viva).
- Gates humanos: PRD, backlog, SDD, MERGE/publicação/deploy. O squad prepara; você aperta o botão.
- Estado sobrevive entre sessões nos ARQUIVOS de `squad\` — "continua a task X do board" retoma.

## Documentos

`PERSONALIZACAO.md` (ajustes por projeto) · `ROADMAP.md` (evolução) · `CHANGELOG.md` ·
`evals\README.md` (como testar mudanças no próprio squad).
