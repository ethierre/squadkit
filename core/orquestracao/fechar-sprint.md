# /fechar-sprint — fechamento de ciclo (memória viva + telemetria)

Rode ao fim de cada sprint/ciclo (ou quando o usuário pedir). Objetivo: o próximo ciclo começa
sabendo tudo que este aprendeu — sem depender da memória de ninguém.

## Passos

1. **Colher o board** — leia `squad\SPRINT.md`: o que fechou, o que ficou, bloqueios, log de handoffs.
2. **Validar contra a realidade** — o que o board diz que fechou está MESMO entregue? (merge feito?
   relatório publicado? peça aprovada?) Divergência = corrigir o board antes de arquivar.
3. **Telemetria** — para cada task do ciclo, acrescente uma linha em `squad\telemetria.csv`:
   `data,task,papel,ciclos_review,bugs_encontrados,resultado` (+ duração/tokens se você tiver).
   Sem inventar: campo que não sabe = vazio. Rode `squad\scripts\dashboard.ps1` —
   ele gera `squad\dashboard.html` com a visão do ciclo.
4. **Atualizar a memória** — acrescente a seção do ciclo em `squad\contexto\HISTORICO.md`:
   o que foi feito e POR QUÊ, decisões tomadas, o que ficou. Fatos canônicos que MUDARAM →
   atualizar `_INDICE.md` (com a evidência).
5. **Extrair lições (anti-poluição)** — só entra lição que teve EVIDÊNCIA no ciclo:
   - Correção/preferência explícita do usuário → `squad\DECISOES.md` (AD-SQ).
   - Aprendizado técnico reutilizável → best-practice do projeto (`squad\_core\best-practices\`
     local) ou ajuste no papel que errou.
   - PROIBIDO: gravar inferência ("o usuário parece preferir...") ou generalizar de 1 caso ambíguo.
6. **Arquivar e limpar** — mova o conteúdo do board para `squad\relatorios\SPRINT-<n>-FECHADA.md`
   e reinicie o `SPRINT.md` (template limpo, campos da próxima sprint).
7. **Retro de 5 linhas ao usuário** — o que funcionou, o que travou, 1-3 melhorias propostas para o
   processo (se aprovadas, viram DECISOES/ajuste de papel — spec-driven vale para o próprio squad).

## Gates

- Board arquivado ≠ realidade → NÃO feche; corrija primeiro.
- Lição sem evidência do ciclo não entra na memória.
- Telemetria é dado real ou vazio — nunca estimativa disfarçada.
