---
name: {{projeto}}-squad
description: Esteira multi-agent spec-driven do squad {{PROJETO}}. Use when o usuário pedir /{{projeto}}-squad, processar uma história/task/demanda do {{PROJETO}} pela esteira, ou rotear trabalho entre os agentes squad-*.
---

🌐 Idioma de saida: **{{IDIOMA}}**. Siga FIELMENTE a esteira em `{{RAIZ}}\squad\_core\orquestracao\esteira.md` — ela é a fonte única
(compartilhada entre CLIs).

Notas específicas do Claude Code:
- Papéis em `.claude\agents\` são SUBAGENTES nativos: despache via Agent tool (paralelo no mesmo
  bloco quando independentes); correção/bug volta ao MESMO agente via SendMessage (contexto vivo).
- O hook anti-burla de testes está ativo (`.claude\hooks\anti-burla-teste.ps1` via settings.json).
- Papel novo criado pelo /montar-squad só vira subagente em SESSÃO NOVA.
