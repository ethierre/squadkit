---
name: fechar-sprint
description: Fecha o ciclo/sprint do squad {{PROJETO}} — valida board vs realidade, registra telemetria, atualiza HISTORICO/fatos canônicos, extrai lições com evidência e arquiva. Use when o usuário pedir /fechar-sprint ou "fecha a sprint/ciclo".
---

🌐 Idioma de saida: **{{IDIOMA}}**. Siga FIELMENTE `{{RAIZ}}\squad\_core\orquestracao\fechar-sprint.md` (fonte única entre CLIs).
No Claude Code, gere o dashboard ao final: `powershell -NoProfile -ExecutionPolicy Bypass -File
{{RAIZ}}\squad\scripts\dashboard.ps1` e informe o caminho do `squad\dashboard.html`.
