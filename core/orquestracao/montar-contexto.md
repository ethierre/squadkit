# /montar-contexto — a porta de entrada do squad (rode ANTES do /montar-squad)

Você (a IA que o usuário está usando — Claude Code, Cursor, Codex, ou outra) vai construir a BASE
DE CONHECIMENTO do projeto {{PROJETO}}. É ela que faz o squad acertar: agente com contexto ruim
erra com confiança. Saída: `squad\contexto\_INDICE.md` (mapa + fatos canônicos) e
`squad\contexto\HISTORICO.md` (memória e rumo). Artefatos intermediários em `squad\_build\`
(retome de lá se interromper).

## Fase 1 — ENTREVISTA (o que é isto e o que você quer)

Pergunte UMA por vez, máximo 8, adaptando ao que a pessoa é (dev sênior OU alguém organizando a
vida pessoal — a esteira serve aos dois):
1. O que é o projeto/trabalho em 1 parágrafo? O que você FAZ e o que QUER PASSAR a fazer com o squad?
2. Quais os entregáveis recorrentes? (código? relatórios? vídeos? agenda organizada? campanhas?)
3. Onde vive o material? (repos git, pastas de docs, planilhas, board tipo Jira/DevOps/Trello,
   agenda, drive) — peça caminhos/URLs concretos.
4. Quem decide o quê? (só você? tem PO/chefe/cliente? o que precisa de aprovação de terceiro?)
5. Quais ações são IRREVERSÍVEIS ou sensíveis? (publicar, enviar, pagar, deletar, mexer em produção)
6. Restrições do domínio? (legais — LGPD/CDC/compliance —, de marca, de horário, de orçamento)
7. O que costuma dar errado hoje? (vira regra canônica de prevenção)
8. Há credenciais/acessos que o squad usará? (onde ficam — regra: uso para ACESSO, nunca em entregável)

Grave `squad\_build\entrevista.md`.

## Fase 2 — INGESTÃO (ler o que existe)

1. Liste tudo que o usuário despejou em `squad\contexto\` + fontes citadas na entrevista.
2. Leia por camadas: primeiro títulos/sumários de tudo → classifique [VIVO] (referência atual) vs
   [HISTORICO] (registro de época) → depois leia por completo só os VIVOS e os históricos que
   parecerem conter decisões. `.docx` é zip (extraia `word/document.xml` e limpe as tags);
   planilhas: leia cabeçalhos e amostra.
3. Se há CÓDIGO: clone/atualize local e verifique os fatos-chave no código real (versões, nomes,
   numerações, o que está implementado de verdade). Se há BOARD com API: puxe contagens/estados.
   **Plano é intenção; código e board são fatos.**

Grave `squad\_build\inventario.md` (arquivo → 1 linha → classificação → confiança).

## Fase 3 — CAÇA ÀS CONTRADIÇÕES (o passo que evita os erros caros)

Compare os documentos ENTRE SI e contra código/board/planilhas. Procure ativamente:
- **Valores que mudaram**: versões, nomes, IDs, metas, datas, preços, regras ("doc de maio diz X,
  doc de julho diz Y").
- **Numerações/sequências**: próxima migração/relatório/episódio — o head REAL manda.
- **Decisões revertidas**: algo aprovado e depois substituído (vale o mais recente COM evidência).
- **Promessas não implementadas**: doc diz "existe", código/planilha diz que não.

Para CADA contradição: resolva pela evidência mais forte (código > board > doc recente > doc
antigo) e registre no quadro de FATOS CANÔNICOS: tema · o que vale · onde os docs divergem.
Se a evidência não resolve → vira PERGUNTA ao usuário (uma por vez) — nunca escolha em silêncio.

## Fase 4 — GERAÇÃO → GATE HUMANO

1. **`squad\contexto\_INDICE.md`**: regras de manuseio (segredos = acesso-sim/entregável-nunca;
   como ler .docx; VIVO vs HISTORICO) · **⭐ FATOS CANÔNICOS** (a tabela da Fase 3) · documentos
   VIVOS (1 linha cada: o quê/quando ler) · HISTÓRICOS · fontes fora da pasta (caminho absoluto/URL).
2. **`squad\contexto\HISTORICO.md`**: o que já foi feito e POR QUÊ (por sprint/fase/mês), estado
   atual VERIFICADO, para onde vai (metas/roadmap), dívidas e pendências transversais.
3. Apresente os dois ao usuário com as 5 descobertas mais importantes (especialmente contradições
   resolvidas) e **PARE para aprovação**. Ajuste e reapresente até aprovar.

## Ciclo de vida do canon (depois do primeiro build)

Fato canônico MUDOU (nova decisão, ambiente alterado)? Atualize o `_INDICE.md` com a evidência
nova E gere um mini **relatório de impacto**: quais documentos/papéis/specs referenciam o fato
antigo e precisam propagar (✅ atualizado / ⚠ pendente). Regra de ouro (do spec-kit): conflito
com o canon se resolve corrigindo spec/task/doc — **nunca diluindo o canon** para acomodar.

## Gates de build (BLOCKING)

- Todo fato canônico tem a EVIDÊNCIA anotada (arquivo/comando/URL) — canon sem fonte não entra.
- Nenhuma contradição encontrada fica sem resolução ou sem pergunta aberta.
- Segredo encontrado em doc: registre ONDE está, nunca reproduza o valor no índice.
- NUNCA fabrique: o que não foi verificado entra como "não verificado", não como fato.

## Fechamento

Sugira o próximo passo: **`/montar-squad`** — ele vai usar a entrevista + o índice para propor os
papéis. Registre no `squad\DECISOES.md` que o contexto foi montado (data, nº de docs, nº de fatos
canônicos, contradições resolvidas).
