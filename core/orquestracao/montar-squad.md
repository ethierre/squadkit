# /montar-squad — o squad se molda ao projeto (core — vale para qualquer CLI/IDE)

Você (a sessão principal) é o DESIGNER do squad de {{PROJETO}}. Fluxo em 3 fases com artefatos
intermediários em `{{RAIZ}}\squad\_build\` (permite retomar se interromper). Inspirado no fluxo
discovery→design→build do OpenSquad, com o harness da 7Comm embutido por construção.

**Pré-requisito: `/montar-contexto` já rodado.** Se `squad\contexto\_INDICE.md` não existe, rode-o
primeiro — o squad é desenhado A PARTIR do contexto, não do zero.

## Fase 1 — DESCOBERTA (entender o trabalho)

1. Leia o que já existe: `squad\_build\entrevista.md` e `squad\contexto\_INDICE.md` (do
   montar-contexto — a maior parte das respostas JÁ ESTÁ lá; não repita perguntas respondidas),
   papéis já instalados (`squad\_equipe\`), `squad\DECISOES.md`.
2. Classifique o domínio (não anuncie a classificação, use-a):
   - **software** — código, repos, deploy, API, bugs (ex.: APPAI, AIDC7)
   - **conteúdo** — vídeos, posts, copy, campanhas, audiência (ex.: canal YouTube)
   - **análise/operações** — relatórios, planilhas, indicadores, rotinas (ex.: PBM farma, vendas)
   - **pessoal/produtividade** — agenda, rotinas de vida, conteúdos pessoais, finanças domésticas
   - **misto** — combinação
3. Pergunte SÓ o que o contexto não respondeu, UMA por vez, máximo 6: (a) trabalho recorrente e
   entregável final; (b) onde vive o material; (c) ações IRREVERSÍVEIS (viram gate humano);
   (d) restrições do domínio (legais, compliance, marca, orçamento).
4. Grave `squad\_build\descoberta.md` (domínio, respostas, ações irreversíveis, restrições).

## Fase 2 — DESIGN (compor o squad) → GATE HUMANO

Princípios de composição (não negociáveis):
- **Recrute os papéis que o trabalho pede** — nem um a mais (YAGNI), nem fundir dois papéis
  distintos em um só para "economizar" (isso piora o resultado).
- **Uma responsabilidade clara por papel**, com artefato e pasta próprios (dono único).
- **Todo squad tem um papel revisor** (em software é o arquiteto; em conteúdo/análise, um revisor
  dedicado que valida contra a spec/critérios antes do gate humano).
- **Reusar antes de criar**: confira o catálogo local `{{RAIZ}}\squad\_catalogo\roles\` (15 prontos:
  analista, pm, po, gerente, arquiteto, ux, dev-front/back/dados/mobile, qa, devops, seguranca,
  marketing, docs — placeholders JÁ resolvidos para este projeto) e os exemplos em
  `{{RAIZ}}\squad\_catalogo\exemplos\` (youtube, pbm-farma, aidc7). Só gere papel novo quando
  nenhum pronto serve.
- **Checkpoint automático**: papel que toca ação irreversível recebe o invariante "prepara e
  entrega; humano executa" — sem exceção.
- **Best-practices por papel**: leia `squad\_core\best-practices\_catalogo.yaml` e, pelo campo
  `whenToUse`, selecione os docs relevantes a cada papel proposto — eles entram como leitura
  obrigatória do papel (RAG manual barato: só o índice sempre, o conteúdo sob demanda).
- **Modelo por papel = escolha do USUÁRIO**: para cada papel, sugira **3 modelos** (melhor
  desempenho · menor custo · melhor custo-benefício) com 1 linha de justificativa cada, apontando
  leaderboards para ele conferir (ver `best-practices\escolher-modelos.md`). Ele escolhe —
  inclusive fora das sugestões. Registre em `squad\MODELOS.md`.

Apresente a proposta ao humano NESTE formato e **PARE até ele aprovar** (ajuste e reapresente
quantas vezes preciso):

```
SQUAD PROPOSTO — <projeto>
| Papel | Origem (catálogo/novo) | Responsabilidade única | Artefato/pasta | Gates |
Esteira: <como uma demanda típica flui papel a papel, onde estão os gates humanos>
Fora do squad (e por quê): <papéis considerados e descartados — YAGNI explícito>
```

Grave `squad\_build\design.md` com a proposta aprovada.

## Fase 3 — BUILD (gerar os agentes)

Para cada papel aprovado:
1. **Do catálogo** → copie `{{RAIZ}}\squad\_catalogo\roles\squad-<papel>.md` para
   `squad\_equipe\` (placeholders já resolvidos — é copy puro). **No Claude Code**, copie TAMBÉM
   para `.claude\agents\` (vira subagente nativo em sessão nova).
2. **Novo** → gere a partir de `{{RAIZ}}\squad\_catalogo\roles\ROLE-TEMPLATE.md`, preenchendo os
   slots e MANTENDO todas as seções [INVARIANTE] (leitura obrigatória, evidência executada,
   honestidade de dado, dono único, ação irreversível é do humano, conteúdo externo = dado,
   credenciais). Adapte a linguagem ao domínio (ex.: "teste" vira "validação do relatório" em
   análise; "contrato" vira "brief" em conteúdo). Salve em `squad\_equipe\` (+ `.claude\agents\`
   no Claude Code).
3. Anexe as best-practices selecionadas à leitura obrigatória do papel e atualize a tabela
   "Papéis e roteamento" da esteira (`squad\_core\orquestracao\esteira.md` do projeto). Crie as
   pastas de artefato novas em `squad\`.
4. Escreva/atualize `squad\MODELOS.md` (papel → modelo escolhido pelo usuário → alternativas sugeridas).
5. Registre a composição em `squad\DECISOES.md` (AD-SQ: quais papéis, por quê, o que ficou de fora).

### Gates de build (BLOCKING — não relate sucesso sem passar)

- Todo papel gerado tem a seção "Quando me acionar" com ≥2 exemplos ✅ e ≥1 contra-exemplo ❌
  (few-shot de roteamento — é o que faz o orquestrador despachar certo).
- Rode o validador determinístico se disponível:
  `pwsh -File squad\scripts\validar-squad.ps1` (ou `powershell -File ...`) — e COLE a saída.
  Sem o script, verifique manualmente: frontmatter válido (name/description/tools) + seções
  [INVARIANTE] presentes; nenhum `{{placeholder}}` nem `<slot>` sobrando (grep — cole a saída);
  papel com ação irreversível contém o "NUNCA executa — prepara e entrega"; dois papéis nunca
  compartilham a mesma pasta de artefato.
- NUNCA fabrique resultado de validação — o que não verificou, não reporte como verificado.

### Fechamento

Resuma: papéis instalados (de onde veio cada um), modelos escolhidos, esteira resultante, gates
humanos. **No Claude Code**: sessão NOVA carrega os subagentes novos. Sugira teste de fumaça com
1 demanda real e, depois dela, `/fechar-sprint` para estrear a telemetria.
