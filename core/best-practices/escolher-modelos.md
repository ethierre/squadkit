# Escolher modelos — o usuário decide, o squad sugere

Regra do produto: **quem define o modelo de cada papel/tarefa é o USUÁRIO FINAL.** O squad ajuda
com **3 sugestões** por papel — nunca impõe, e o usuário pode escolher fora da lista.

## O padrão das 3 sugestões

| Slot | Critério | Exemplo de justificativa |
|---|---|---|
| 🏆 Desempenho | melhor resultado na categoria da tarefa | "melhor em código/agentes no leaderboard" |
| 💰 Custo | mais barato que resolve o essencial | "suficiente p/ triagem/resumo; 10-20× mais barato" |
| ⚖️ Custo-benefício | o equilíbrio que a maioria deveria usar | "90% do topo por fração do preço" |

Sempre com 1 linha de justificativa + o convite: "confira os leaderboards e escolha — inclusive
outro modelo".

## Onde conferir (fontes vivas — rankings mudam todo mês, NÃO decore)

- **LMArena** (https://lmarena.ai/leaderboard — também citado como arena.ai): ranking por
  categoria (texto, código, visão, imagem) via voto humano cego.
- **Artificial Analysis** (https://artificialanalysis.ai): qualidade × preço × velocidade —
  o melhor para o slot custo-benefício.
- Leaderboards específicos: SWE-bench (código/agentes), benchmarks de imagem/vídeo/voz da
  categoria em questão.

## Sugestão por TIPO de tarefa (o slot, não o modelo — o nome vigente sai do leaderboard)

- **Código/agente autônomo** → topo do SWE-bench/código; custo-benefício = tier médio da mesma família.
- **Triagem, resumo, rotina simples** → modelo pequeno/rápido; pagar topo aqui é desperdício.
- **Geração de imagem** → topo da arena de imagem (ex. de slots: um "nano/flash" para volume, um
  topo de linha para qualidade final, um intermediário como equilíbrio).
- **Escrita longa/criativa** → arena de texto/creative writing.
- **Análise de dados/raciocínio** → modelos de raciocínio; atenção ao custo por token de "thinking".

## Registro

A escolha vai em `squad\MODELOS.md` (papel → modelo escolhido → alternativas sugeridas → data).
Revisitar a cada ciclo relevante: modelos e preços mudam rápido — a telemetria do squad
(`telemetria.csv`) mostra onde vale subir ou descer de tier.
