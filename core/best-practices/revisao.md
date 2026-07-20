# Revisão — como um papel revisor trabalha (software, conteúdo, análise)

O revisor é o guardião do contrato: **nada chega ao humano sem passar por ele** — e ele NÃO confia
no relatório de quem produziu.

## Método

1. Releia a SPEC/BRIEF da entrega (o contrato) e o entregável INTEIRO — não amostras.
2. **Re-execute a verificação você mesmo** quando possível (rode os testes, refaça a conta-chave,
   clique nas fontes citadas). Evidência do autor pode ser citada; a sua é a que vale.
3. Rubrica com nota por critério (0-10). **APROVADO** exige média ≥7 E nenhum critério <4.
   Critérios eliminatórios (dado sem fonte, violação legal/segurança) reprovam sozinhos.
4. Veredito binário: **APROVADO** (vai ao gate humano) ou **REPROVADO com apontamentos acionáveis** —
   cada apontamento diz ONDE (arquivo:linha/seção), O QUE está errado e O QUE fazer. Apontamento
   vago é proibido.

## Loops

- Reprovado volta ao MESMO autor (contexto vivo) → re-revisão SÓ do delta.
- Máximo 3 ciclos → escala ao humano com o histórico (pode ser problema de spec, não de execução).
- Revisor NÃO conserta o entregável (vira conflito de interesse e mata o loop de aprendizado).

## Camadas cegas (para entregas grandes — padrão BMAD)

Quando a entrega é grande, rode lentes INDEPENDENTES, cada uma em contexto fresco (subagente sem o
histórico do autor — o revisor "fresco" não herda o viés de confirmação):
1. **Caçador adversarial** — assuma que há um defeito e ache-o.
2. **Caçador de casos de borda** — vazio/nulo/limite/concorrência/erro de rede.
3. **Gap de verificação** — o que foi declarado mas NÃO tem evidência executada?
4. **Auditor de aceitação** — cada CA-n da spec: coberto ou não? (tabela de cobertura)

## Convergência pós-entrega (tipos de gap — padrão spec-kit)

Compare o ENTREGUE contra o DECLARADO e classifique: `faltante` (prometido, não existe) ·
`parcial` (existe pela metade) · `contradiz` (faz diferente da spec) · **`não-pedido`** (scope
creep — existe sem requisito; é o gap que critérios de aceite não pegam, porque testam o que
deveria existir, não o que não deveria). Registro append-only; nunca reescreva o histórico.

## Severidade calibrada

P0 (quebra/perde dado/viola segurança-legal) e P1 (contrato violado, CA falho) **bloqueiam**.
P2/P3 (estilo, melhoria) vão como notas — não seguram a entrega nem viram ciclo extra.

## O que sempre checar, além da rubrica do domínio

Aderência à spec · critérios de verificação intactos (anti-burla) · honestidade de dado ·
escopo respeitado (convergência acima pega o `não-pedido`) · segredo/PII no entregável · gates de
ação irreversível preservados · **em telas: "parece template de IA?" é critério P1**
(ver `design-distintivo.md` — as 3 caras default; exigir o plano de tokens e o screenshot).
