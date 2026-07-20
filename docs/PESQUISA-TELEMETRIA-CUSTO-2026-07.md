# Pesquisa — telemetria de tokens/custo por CLI (jul/2026)

> Resumo executivo para a frente "telemetria de custo real" do roadmap. Conclusão: **captura no
> cliente (logs/saída do CLI) é a única via por-task universal**; APIs de provedor servem para
> reconciliação mensal e não cobrem planos por assinatura.

## Viabilidade por ferramenta

| Ferramenta | Melhor mecanismo | Granularidade | Confiabilidade |
|---|---|---|---|
| **Claude Code (headless)** | JSON do `claude -p --output-format json`: `total_cost_usd`, `usage`, `session_id` | **por task** | Alta (oficial) |
| **Claude Code (interativo)** | transcript JSONL `~/.claude/projects/...` (`message.usage` por mensagem) + hook `SessionEnd` (recebe `session_id`+`transcript_path` → mapeia task↔transcript) | por sessão/mensagem | Alta p/ tokens; custo = tokens × tabela |
| **Codex CLI** | eventos `token_count` (cumulativos) em `~/.codex/sessions/`; `codex exec --json` → `turn.completed.usage` | por turno | Média (formato experimental) |
| **Gemini CLI / Copilot CLI / OpenCode** | suportados pelo **ccusage** (parser multi-CLI, 15+ fontes) | por sessão | Média-alta |
| **Cursor** | Admin API `/teams/filtered-usage-events` (tokens+cents) — **só Enterprise**; individual = CSV manual do dashboard | por evento/usuário | Alta (Ent) / manual |
| **Windsurf** | Cascade Analytics API — **créditos**, não tokens (e Cascade EOL 07/2026) | usuário/período | Baixa p/ task |
| **Antigravity** | nada programático (só quota % no dashboard) | — | Baixa → manual |
| **APIs de provedor** (Anthropic/OpenAI usage+cost) | buckets 1m/1h/1d por key/workspace | não atribui a task | Reconciliação mensal |

## Arquitetura recomendada (a implementar)

`telemetria.csv` ganha colunas: `tokens_in, tokens_out, tokens_cache_read, tokens_cache_write,
custo_usd, fonte(medido|estimado|manual), billing_mode(api|assinatura)`.

1. **Claude Code = caminho ouro**: headless captura o JSON de resultado direto; interativo usa
   hook `SessionEnd` para mapear task↔transcript e o `fechar-sprint` soma `message.usage` dos
   transcripts (deduplicar por `message.id`+`requestId` — resume/compact duplicam) × tabela de
   preços do MODELOS.md (fecha o loop com a recomendação de modelos).
2. **Codex/Gemini/Copilot CLI**: delegar ao `ccusage --json` como backend de parsing; `fonte=estimado`.
3. **Cursor/Windsurf/Antigravity IDE**: `fonte=manual`; enriquecedor opcional Enterprise no fechar-sprint.
4. **Reconciliação mensal** opcional contra Anthropic/OpenAI cost APIs (quando billing=api).

## Riscos

Formatos internos instáveis (parser defensivo: campo ausente → `fonte=manual`) · custo em
assinatura é nocional (registrar `billing_mode`) · dupla contagem em resume/subagentes
(deduplicar) · preços mudam (gravar tokens crus + versão da tabela) · paths por env
(`CLAUDE_CONFIG_DIR`, `CODEX_HOME`), nunca hardcode.

Fontes completas no relatório interno de 19/07/2026 (code.claude.com/docs/en/monitoring-usage,
ccusage.com, cursor.com/docs/account/teams/admin-api, platform.claude.com usage-cost-api, etc.).
