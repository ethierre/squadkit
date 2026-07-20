# Personalização por projeto — o que ajustar depois de instalar

O instalador resolve os placeholders básicos. O que fica por sua conta (ordem recomendada):

## 0. Os botões do instalador (referência rápida)

- `-Interativo` — instalação guiada por 6 perguntas (para quem não quer flags).
- `-Perfil <nome>` (ver perfis.json) OU `-Papeis a,b,c` — quais papéis instalar; `sob-medida`
  instala só o arquiteto e deixa o `/montar-squad` desenhar o resto.
- `-Ide claude,cursor,antigravity,codex,vscode,generico` — adapters instalados (AGENTS.md e
  `squad\INICIAR.md` vão sempre).
- Manifesto `squad\.squadkit.json` — gravado na instalação; guarda os parâmetros e o
  **`diffMaximo`** (orçamento de diff do review, default 400 linhas — ajuste ali).
- Atualizar depois: `pwsh -File atualizar-squad.ps1 -Destino <pasta>` (sincroniza `_core`,
  scripts e catálogo sem tocar contexto/equipe/board).

## 1. Placeholders (o instalador já substitui — confira)

| Placeholder | Significado | Exemplo 7Risk |
|---|---|---|
| `{{PROJETO}}` | Nome do projeto | 7Risk |
| `{{projeto}}` | Slug minúsculo (nome da skill/pastas) | 7risk |
| `{{RAIZ}}` | Pasta raiz do hub (onde .claude e squad\ vivem) | C:\7comm |
| `{{BRANCH}}` | Branch de integração dos repos | develop |
| `{{CLONES}}` | Pasta dos clones locais dos repos | C:\7comm\_repos7risk |
| `{{BOARD}}` | Ferramenta de board/cards | Azure DevOps (org CN-Squad) |

## 2. Papéis do squad (`.claude\agents\`)

A instalação já traz os papéis do `-Perfil` escolhido (ou da lista `-Papeis`). Ajustes:
- **Adicionar papel depois**: copie `roles\squad-<papel>.md` do template para `.claude\agents\` do
  projeto e faça o find/replace dos placeholders (tabela do §1). Sessão NOVA do Claude Code carrega.
- **Remover papel**: apague o .md — a esteira se adapta (fallbacks na SKILL).
- Em CADA agente dev/devops: preencha o(s) repo(s) de trabalho no marcador `← AJUSTAR NA INSTALAÇÃO`.
- `squad-seguranca` roda FORA da esteira (auditoria manual read-only); `squad-marketing` nunca
  publica; `squad-devops` nunca aplica em produção — esses gates são invariantes.

## 3. Base de conhecimento (`squad\contexto\`)

É o que faz o squad não errar:
- Despeje os documentos do projeto em `squad\contexto\` (visão, arquitetura, contratos,
  histórias, atas — md, docx, planilhas).
- Rode **`/montar-contexto`** na sua IA: ele entrevista você, lê tudo, caça contradições e gera o
  `_INDICE.md` (fatos canônicos com evidência) + `HISTORICO.md`, fechando com o Resumo de
  Entendimento para você confirmar.
- Credenciais: se colocar arquivo de credenciais no contexto, a regra dos agentes é usar para ACESSO
  e nunca copiar segredo para entregável. Prefira cofre (Key Vault etc.) quando existir.

## 4. Decisões vigentes (`squad\DECISOES.md`)

Preencha a seção "herdadas do projeto" com as regras invioláveis locais (convenções de wire/banco,
branch, "never do"). No 7Risk: camelCase no fio, dinheiro string, NUMERIC(18,2), RLS, develop.

## 5. Enforcement anti-burla (3 camadas — ative as que couberem)

1. **Hook do Claude Code/VS Code** (`.claude\hooks\anti-burla-teste.ps1` + `guard-git.ps1`,
   instalados com `-Ide claude`): bloqueia alteração de teste rastreado e comandos git com
   `--no-verify`/`core.hooksPath`. Ajuste os PADRÕES DE ARQUIVO DE TESTE à stack (regex no topo);
   teste NOVO do próprio dev é liberado.
2. **Hook git universal (qualquer IDE)** — rode POR REPOSITÓRIO de trabalho:
   `pwsh -File squad\scripts\instalar-hook-git.ps1 -Repo <caminho-do-clone>` — é a única camada
   anti-burla para quem usa Cursor/Codex/Antigravity sem os hooks da IDE.
3. **Hooks de Cursor/Antigravity** (instalados com `-Ide cursor`/`antigravity`): guarda de git
   nos formatos nativos (`.cursor\hooks.json`, `.agents\hooks.json`) — schemas em beta; confira
   a doc da sua versão.

Requisito dos hooks: PowerShell (nativo no Windows; macOS/Linux: instale `pwsh` — o instalador já
grava o executável certo do seu SO).

## 6. Board/cards (DevOps, GitLab, Jira)

A SKILL referencia o board de forma genérica. Se houver API (como o Azure DevOps do 7Risk), documente
no `_INDICE.md` como acessar (URL, onde está o PAT) — o arquiteto valida cards × doc × código.

## 7. Sync de skills (`squad\scripts\sync-skills.ps1`) — OPCIONAL

Só faz sentido se os repos do projeto têm skills `.claude/skills` versionadas (padrão 7Risk).
Edite a lista `$repos` (ids/URLs) no script. Se não usar, apague o script e as menções na SKILL.

## 8. Teste de fumaça (recomendado)

Rode a esteira com UMA task pequena e real (`/<slug>-squad executar <task>`) antes de adotar no
dia a dia — foi assim que o 7Risk calibrou (piloto FE-17). Ajuste o que atritar e registre a
preferência na SKILL para as próximas sessões.
