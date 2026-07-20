---
name: {{projeto}}-squad
description: Esteira multi-agent spec-driven do squad {{PROJETO}}. Use when o usuário pedir /{{projeto}}-squad, processar uma história/task/demanda do {{PROJETO}} pela esteira, ou rotear trabalho entre os agentes squad-*.
---

🌐 Idioma de saida: **{{IDIOMA}}**. Siga FIELMENTE a esteira em `{{RAIZ}}\squad\_core\orquestracao\esteira.md` — ela é a fonte única
(compartilhada entre CLIs).

Notas específicas do Claude Code:
- **A esteira roda inteira NESTA conversa** — nunca peça ao usuário para fechar/reabrir o chat para
  um papel pegar a task. Você despacha um papel após o outro sem interrupção.
- Papéis em `.claude\agents\` são SUBAGENTES nativos: despache via Agent tool (paralelo no mesmo
  bloco quando independentes); correção/bug volta ao MESMO agente via SendMessage (contexto vivo).
- O hook anti-burla de testes está ativo (`.claude\hooks\anti-burla-teste.ps1` via settings.json).
- Sessão nova SÓ é necessária uma vez, logo após o /montar-squad CRIAR papéis novos (para o Claude
  Code registrá-los como subagentes) — nunca durante a operação de uma task.
