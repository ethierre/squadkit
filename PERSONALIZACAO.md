# Personalização por projeto — o que ajustar depois de instalar

O instalador resolve os placeholders básicos. O que fica por sua conta (ordem recomendada):

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

É o que faz o squad não errar. Siga o `contexto\README.md`:
- Despeje os documentos do projeto (visão, arquitetura, contratos, histórias, atas).
- Monte o `_INDICE.md` (mapa + **FATOS CANÔNICOS** que resolvem contradições entre docs) e o
  `HISTORICO-SPRINTS.md` (o que foi feito, por quê, para onde vai). Peça ao Claude: "leia o contexto e
  monte o índice e o histórico como no 7Risk" — é trabalho de 1 sessão.
- Credenciais: se colocar arquivo de credenciais no contexto, a regra dos agentes é usar para ACESSO
  e nunca copiar segredo para entregável. Prefira cofre (Key Vault etc.) quando existir.

## 4. Decisões vigentes (`squad\DECISOES.md`)

Preencha a seção "herdadas do projeto" com as regras invioláveis locais (convenções de wire/banco,
branch, "never do"). No 7Risk: camelCase no fio, dinheiro string, NUMERIC(18,2), RLS, develop.

## 5. Hook anti-burla (`.claude\hooks\anti-burla-teste.ps1`)

Ajuste os PADRÕES DE ARQUIVO DE TESTE à stack do projeto (regex no topo do script). Padrões inclusos:
`*.spec.ts/js`, `*.test.ts/js`, `*Tests.cs`, `__tests__\`, `tests\*.sql`, `*_test.py/go`.
O hook LIBERA arquivo de teste ainda não rastreado no git (criado agora pelo dev) — só bloqueia
alteração de teste que já existia na branch.

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
