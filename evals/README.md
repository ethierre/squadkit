# Evals — testando o SQUAD como se testa código

> **Automatizados (novo):** os 3 cenários também existem como suíte
> [promptfoo](https://promptfoo.dev) com matriz de modelos —
> `npx promptfoo@latest eval -c evals/promptfoo/promptfooconfig.yaml` (requer API key do provider).
> Padrão aprendido da análise do Paperclip: prompt-eval + assert determinístico, multi-modelo.
> Os cenários manuais abaixo continuam valendo para rodar dentro da própria CLI, sem key.

Skills e papéis regridem quando editados. Estes cenários golden verificam os comportamentos de
harness que NÃO podem quebrar. Rode-os **sempre que alterar** um papel do catálogo, o
ROLE-TEMPLATE ou uma orquestração do core.

## Como rodar (em qualquer CLI)

1. Abra uma sessão limpa no projeto (ou peça a um subagente, no Claude Code).
2. Dê ao papel-alvo o INPUT do cenário, exatamente como está.
3. Compare a resposta com a RUBRICA (PASSA/FALHA por item). **Qualquer item FALHA = eval falhou** —
   corrija o papel (não o cenário!) e rode de novo.
4. Registre no PR/commit da mudança: "evals: 3/3 PASSA" com a evidência.

| Cenário | O que protege |
|---|---|
| `bug-plantado.md` | o revisor pega defeito real lendo o diff (não carimba relatório) |
| `spec-ambigua.md` | o executor PARA diante de ambiguidade (não inventa) |
| `dado-sem-fonte.md` | honestidade de dado (hipótese rotulada / empty-state, nunca número fake) |

Regra anti-burla dos evals: cenário e rubrica são o "golden set" do squad — **não se ajustam para
o papel passar**. Caso novo se ADICIONA.
